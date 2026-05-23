import Foundation

/// Describes the native macOS screenshot command used by the app.
///
/// `screencapture -i -c` asks macOS to show its built-in interactive region
/// picker and writes the selected image directly to the clipboard. Keeping
/// this as a small value type makes the app behavior easy to verify in tests.
public struct CaptureCommand: Equatable {
    public let executableURL: URL
    public let arguments: [String]

    public init(executableURL: URL, arguments: [String]) {
        self.executableURL = executableURL
        self.arguments = arguments
    }

    public static let interactiveClipboard = CaptureCommand(
        executableURL: URL(fileURLWithPath: "/usr/sbin/screencapture"),
        arguments: ["-i", "-c"]
    )
}
