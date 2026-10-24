import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private lazy var menuBar = MenuBar { [weak self] path in self?.showMainWindow(opening: path) }

  // FlutterAppDelegate does not implement this, so there is no super to call.
  override func applicationDidFinishLaunching(_ notification: Notification) {
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
        Self.pressMediaKey(call.arguments as? String)
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

  /// Presses a media key like F7–F9 do; the Now Playing app takes it.
  /// Posting events needs Privacy & Security > Accessibility, which the
  /// first press asks for.
  private static func pressMediaKey(_ name: String?) {
    // NX_KEYTYPE_PLAY, _NEXT and _PREVIOUS from IOKit's ev_keymap.h.
    guard let key = ["playPause": 16, "next": 17, "previous": 18][name ?? ""] else { return }
    guard CGPreflightPostEventAccess() else {
      CGRequestPostEventAccess()
      return
    }
    for down in [true, false] {
      let event = NSEvent.otherEvent(
        with: .systemDefined, location: .zero,
        modifierFlags: NSEvent.ModifierFlags(rawValue: down ? 0xa00 : 0xb00),
        timestamp: 0, windowNumber: 0, context: nil, subtype: 8,
        data1: key << 16 | (down ? 0xa : 0xb) << 8, data2: -1)
      event?.cgEvent?.post(tap: .cghidEventTap)
    }
  }

  // A click anywhere else, ⌘Tab or opening the main window closes it.
  func windowDidResignKey(_ notification: Notification) {
    hide()
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
