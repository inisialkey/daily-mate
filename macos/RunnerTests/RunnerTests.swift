import CoreGraphics
import XCTest

@testable import DailyMate

class RunnerTests: XCTestCase {

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
