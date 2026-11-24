import CoreGraphics
import XCTest

@testable import DailyMate

class RunnerTests: XCTestCase {

  // The test host is the Debug app with the real bundle id. Flutter must stay
  // off in it, or every run would open the user's real database.
  func testTestHostRunsWithoutFlutter() {
    XCTAssertTrue(TestHost.isActive)
    let windows = NSApp.windows.compactMap { $0 as? MainFlutterWindow }
    XCTAssertEqual(windows.count, 1)
    XCTAssertNil(windows.first?.contentViewController)
  }

  // A real arrow press carries NumericPad and SecondaryFn; without them a
  // global shortcut on an arrow (MixMusic's next/previous) never fires.
  func testShortcutOnAnArrowKeepsTheArrowFlags() {
    let events = MenuBar.shortcutEvents(keyCode: 124, modifiers: ["command", "control", "option"])

    XCTAssertEqual(events.map { $0.type }, [.keyDown, .keyUp])
    for event in events {
      XCTAssertEqual(event.getIntegerValueField(.keyboardEventKeycode), 124)
      XCTAssertTrue(event.flags.isSuperset(of: [
        .maskCommand, .maskControl, .maskAlternate, .maskNumericPad, .maskSecondaryFn,
      ]))
      XCTAssertFalse(event.flags.contains(.maskShift))
    }
  }

  func testShortcutOnALetterHasOnlyItsModifiers() {
    let events = MenuBar.shortcutEvents(keyCode: 35, modifiers: ["shift", "bogus"])

    for event in events {
      XCTAssertTrue(event.flags.contains(.maskShift))
      XCTAssertFalse(event.flags.contains(.maskNumericPad))
      XCTAssertFalse(event.flags.contains(.maskCommand))
    }
  }
}
