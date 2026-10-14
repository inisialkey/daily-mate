import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private var channel: FlutterMethodChannel?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController
    self.setContentSize(NSSize(width: 1280, height: 820))
    self.contentMinSize = NSSize(width: 760, height: 560)
    self.center()
    // Restores the last size and position after the first launch.
    self.setFrameAutosaveName("DailyMateMainWindow")

    // Unified look: Flutter draws under a transparent title bar; the sidebar
    // leaves room for the traffic lights.
    self.titlebarAppearsTransparent = true
    self.titleVisibility = .hidden
    self.styleMask.insert(.fullSizeContentView)

    RegisterGeneratedPlugins(registry: flutterViewController)
    registerChannel(flutterViewController.engine.binaryMessenger)

    super.awakeFromNib()

    // The main menu finishes loading after the window; wire it afterwards.
    DispatchQueue.main.async { [weak self] in self?.wireSettingsMenuItem() }
  }

  private func registerChannel(_ messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "dailymate/window", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return result(nil) }
      switch call.method {
      case "startDrag":
        if let event = self.currentEvent { self.performDrag(with: event) }
        result(nil)
      case "titleBarDoubleClick":
        self.titleBarDoubleClick()
        result(nil)
      case "openUrl":
        // Markdown links only; the Dart side already limits the schemes.
        if let text = call.arguments as? String, let url = URL(string: text),
           ["http", "https", "mailto"].contains(url.scheme?.lowercased() ?? "") {
          NSWorkspace.shared.open(url)
        }
        result(nil)
      case "revealInFinder":
        if let path = call.arguments as? String {
          NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: path)])
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    self.channel = channel
  }

  /// Honors System Settings > Desktop & Dock > "Double-click a window's title bar to".
  private func titleBarDoubleClick() {
    switch UserDefaults.standard.string(forKey: "AppleActionOnDoubleClick") {
    case "Minimize": performMiniaturize(nil)
    case "None": break
    default: performZoom(nil)
    }
  }

  private func wireSettingsMenuItem() {
    guard let appMenu = NSApp.mainMenu?.items.first?.submenu,
          let item = appMenu.items.first(where: { $0.keyEquivalent == "," }) else { return }
    item.title = "Settings…"
    item.target = self
    item.action = #selector(openSettings(_:))
  }

  @objc func openSettings(_ sender: Any?) {
    makeKeyAndOrderFront(nil)
    channel?.invokeMethod("openSettings", arguments: nil)
  }
}
