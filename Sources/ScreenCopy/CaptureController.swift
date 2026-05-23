import AppKit
import ScreenCopyCore

final class CaptureController {
    var onCaptureStateChanged: ((Bool) -> Void)?

    private let command: CaptureCommand
    private var activeProcess: Process?

    init(command: CaptureCommand = .interactiveClipboard) {
        self.command = command
    }

    var isCapturing: Bool {
        activeProcess != nil
    }

    func startCapture() {
        guard activeProcess == nil else {
            return
        }

        guard FileManager.default.isExecutableFile(atPath: command.executableURL.path) else {
            presentLaunchError("Could not find the macOS screenshot tool at \(command.executableURL.path).")
            return
        }

        let process = Process()
        process.executableURL = command.executableURL
        process.arguments = command.arguments

        process.terminationHandler = { [weak self] finishedProcess in
            let status = finishedProcess.terminationStatus

            DispatchQueue.main.async {
                self?.finishCapture(status: status)
            }
        }

        activeProcess = process

        do {
            try process.run()
            onCaptureStateChanged?(true)
        } catch {
            activeProcess = nil
            presentLaunchError("Could not start the screenshot tool: \(error.localizedDescription)")
        }
    }

    func terminateCaptureIfNeeded() {
        activeProcess?.terminate()
        activeProcess = nil
        onCaptureStateChanged?(false)
    }

    private func finishCapture(status: Int32) {
        activeProcess = nil
        onCaptureStateChanged?(false)

        // A non-zero status commonly means the user pressed Escape or canceled
        // the native picker, so the app deliberately stays quiet.
        _ = status
    }

    private func presentLaunchError(_ message: String) {
        NSApp.activate(ignoringOtherApps: true)

        let alert = NSAlert()
        alert.messageText = "ScreenCopy could not start capture"
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
