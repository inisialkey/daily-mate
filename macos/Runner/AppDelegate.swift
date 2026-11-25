import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private lazy var menuBar = MenuBar { [weak self] path in self?.showMainWindow(opening: path) }

  // FlutterAppDelegate does not implement this, so there is no super to call.
  override func applicationDidFinishLaunching(_ notification: Notification) {
    guard !TestHost.isActive else { return }
    menuBar.install()
  }

  // Closing the window keeps DailyMate running (like Mail or Notes) so
  // notification actions are handled immediately; ⌘Q quits. Scheduled
  // notifications are owned by macOS and fire whether or not the app runs.
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  // Clicking the Dock icon brings the closed window back.
  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      mainFlutterWindow?.makeKeyAndOrderFront(nil)
    }
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  private func showMainWindow(opening path: String) {
    NSApp.activate(ignoringOtherApps: true)
    mainFlutterWindow?.makeKeyAndOrderFront(nil)
    (mainFlutterWindow as? MainFlutterWindow)?.open(path)
  }
}

/// XCTest hosts macos/RunnerTests in this Debug app, which has the real bundle id
/// and so the real data container. While it does, neither Flutter engine starts
/// (no database, no notifications) and the tests exercise native code only.
enum TestHost {
  static let isActive = ProcessInfo.processInfo.environment.keys.contains { $0.hasPrefix("XCTest") }
}

/// The menu bar extra. Its panel runs a second, small Flutter app
/// (`menuBarMain` in lib/main.dart) in its own engine; both engines share
/// one database isolate, so a change in either shows up in the other.
///
/// A non-activating panel, not an NSPopover: it takes typing without
/// activating DailyMate, so the main window stays where it is.
final class MenuBar: NSObject, NSWindowDelegate {
  private static let size = NSSize(width: 360, height: 520)

  private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  private let openInApp: (String) -> Void
  private var panel: MenuBarPanel?
  private var engine: FlutterEngine?
  private var channel: FlutterMethodChannel?

  init(openInApp: @escaping (String) -> Void) {
    self.openInApp = openInApp
  }

  func install() {
    guard let button = statusItem.button else { return }
    if #available(macOS 11.0, *) {
      button.image = NSImage(systemSymbolName: "checklist", accessibilityDescription: "DailyMate")
    } else {
      button.title = "DM"
    }
    button.target = self
    button.action = #selector(toggle(_:))
  }

  @objc private func toggle(_ sender: NSStatusBarButton) {
    if let panel = panel, panel.isVisible {
      hide()
      return
    }
    let panel = self.panel ?? makePanel()
    self.panel = panel
    panel.setFrameOrigin(origin(below: sender))
    panel.makeKeyAndOrderFront(nil)
    sender.highlight(true)
  }

  private func hide() {
    panel?.orderOut(nil)
    statusItem.button?.highlight(false)
  }

  /// Centered under the icon, kept on screen.
  private func origin(below button: NSStatusBarButton) -> NSPoint {
    guard let window = button.window else { return .zero }
    let icon = window.convertToScreen(button.convert(button.bounds, to: nil))
    var x = icon.midX - Self.size.width / 2
    if let visible = window.screen?.visibleFrame {
      x = min(max(x, visible.minX + 8), visible.maxX - Self.size.width - 8)
    }
    return NSPoint(x: x, y: icon.minY - Self.size.height - 6)
  }

  /// Built on first use and kept, so later opens are instant. The engine
  /// registers no plugins: path_provider works over FFI, and notifications
  /// must stay with the main engine.
  private func makePanel() -> MenuBarPanel {
    let engine = FlutterEngine(name: "menu_bar", project: nil)
    engine.run(withEntrypoint: "menuBarMain")
    let controller = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    // Flutter draws on the panel's own background, which follows the system
    // appearance like every menu bar extra.
    controller.backgroundColor = .clear

    let channel = FlutterMethodChannel(name: "dailymate/menu_bar", binaryMessenger: engine.binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "open":
        if let path = call.arguments as? String {
          self?.hide()
          self?.openInApp(path)
        }
        result(nil)
      case "isRunning":
        let id = call.arguments as? String ?? ""
        result(!NSRunningApplication.runningApplications(withBundleIdentifier: id).isEmpty)
      case "pressMediaKey":
        result(KeyPresser.pressMediaKey(call.arguments as? String))
      case "pressShortcut":
        let args = call.arguments as? [String: Any]
        result(KeyPresser.pressShortcut(
          keyCode: args?["keyCode"] as? Int,
          modifiers: args?["modifiers"] as? [String] ?? []))
      case "openAccessibilitySettings":
        self?.hide()
        let pane = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        if let url = URL(string: pane) { NSWorkspace.shared.open(url) }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    self.engine = engine
    self.channel = channel

    // Titled for the system's rounded corners and shadow; the title bar is
    // hidden and Flutter draws under it.
    let panel = MenuBarPanel(
      contentRect: NSRect(origin: .zero, size: Self.size),
      styleMask: [.nonactivatingPanel, .titled, .fullSizeContentView],
      backing: .buffered,
      defer: true)
    panel.contentViewController = controller
    panel.setContentSize(Self.size)
    panel.titleVisibility = .hidden
    panel.titlebarAppearsTransparent = true
    for button in [NSWindow.ButtonType.closeButton, .miniaturizeButton, .zoomButton] {
      panel.standardWindowButton(button)?.isHidden = true
    }
    panel.isMovable = false
    panel.isReleasedWhenClosed = false
    panel.hidesOnDeactivate = false
    panel.level = .popUpMenu
    panel.collectionBehavior = [.moveToActiveSpace, .fullScreenAuxiliary]
    panel.delegate = self
    panel.onCancel = { [weak self] in self?.hide() }
    return panel
  }

  // A click anywhere else, ⌘Tab or opening the main window closes it.
  func windowDidResignKey(_ notification: Notification) {
    hide()
  }
}

/// Posts key presses for the menu bar panel's media controls.
enum KeyPresser {
  /// Presses a media key like F7–F9 do; the Now Playing app takes it.
  /// Posting events needs Privacy & Security > Accessibility, which the
  /// first press asks for. False when that grant is missing; macOS asks
  /// only once, so later refusals are silent unless the panel says so.
  static func pressMediaKey(_ name: String?) -> Bool {
    // NX_KEYTYPE_PLAY, _NEXT and _PREVIOUS from IOKit's ev_keymap.h.
    guard let key = ["playPause": 16, "next": 17, "previous": 18][name ?? ""] else { return true }
    guard canPostEvents() else { return false }
    for down in [true, false] {
      let event = NSEvent.otherEvent(
        with: .systemDefined, location: .zero,
        modifierFlags: NSEvent.ModifierFlags(rawValue: down ? 0xa00 : 0xb00),
        timestamp: 0, windowNumber: 0, context: nil, subtype: 8,
        data1: key << 16 | (down ? 0xa : 0xb) << 8, data2: -1)
      event?.cgEvent?.post(tap: .cghidEventTap)
    }
    return true
  }

  /// Presses a key combination, such as a music app's global shortcut; its
  /// owner takes it before the frontmost app. Same permission as above.
  static func pressShortcut(keyCode: Int?, modifiers: [String]) -> Bool {
    guard let keyCode = keyCode, let key = CGKeyCode(exactly: keyCode) else { return false }
    guard canPostEvents() else { return false }
    for event in shortcutEvents(keyCode: key, modifiers: modifiers) {
      event.post(tap: .cghidEventTap)
    }
    return true
  }

  /// Key down and up for [keyCode] with [modifiers]. CGEvent gives an arrow
  /// (and the other keypad and fn keys) NumericPad and SecondaryFn, like a
  /// real press: the modifiers are added to those, since a hotkey on an
  /// arrow does not fire without them. Any other default flag is dropped: a
  /// nil source also copies the modifiers the session last reported (a
  /// shortcut posted moments ago leaves ⌘⌃⌥ there), which would ride along.
  static func shortcutEvents(keyCode: CGKeyCode, modifiers: [String]) -> [CGEvent] {
    let masks: [String: CGEventFlags] = [
      "command": .maskCommand, "control": .maskControl,
      "option": .maskAlternate, "shift": .maskShift,
    ]
    let flags = modifiers.reduce(into: CGEventFlags()) { flags, name in
      if let mask = masks[name] { flags.insert(mask) }
    }
    return [true, false].compactMap { down in
      guard let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: down) else { return nil }
      event.flags = event.flags.intersection([.maskNumericPad, .maskSecondaryFn]).union(flags)
      return event
    }
  }

  /// Whether DailyMate may post events; without the grant, asks for it.
  private static func canPostEvents() -> Bool {
    guard CGPreflightPostEventAccess() else {
      CGRequestPostEventAccess()
      return false
    }
    return true
  }
}

final class MenuBarPanel: NSPanel {
  var onCancel: (() -> Void)?

  override var canBecomeKey: Bool { true }

  /// Esc, also when a focused text field passes it on.
  override func cancelOperation(_ sender: Any?) {
    onCancel?()
  }
}
