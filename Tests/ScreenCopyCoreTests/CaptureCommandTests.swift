import XCTest
@testable import ScreenCopyCore

final class CaptureCommandTests: XCTestCase {
    func testInteractiveClipboardCommandUsesNativeScreenshotTool() {
        let command = CaptureCommand.interactiveClipboard

        XCTAssertEqual(command.executableURL.path, "/usr/sbin/screencapture")
        XCTAssertEqual(command.arguments, ["-i", "-c"])
    }
}
