import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let captureController = CaptureController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        configureStatusItem()

        captureController.onCaptureStateChanged = { [weak self] isCapturing in
            self?.updateStatusItem(isCapturing: isCapturing)
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        captureController.terminateCaptureIfNeeded()
    }

    private func configureStatusItem() {
        guard let button = statusItem.button else {
            return
        }

        button.target = self
        button.action = #selector(statusItemClicked(_:))
        _ = button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        updateStatusItem(isCapturing: false)
    }

    private func updateStatusItem(isCapturing: Bool) {
        guard let button = statusItem.button else {
            return
        }

        if let image = NSImage(
            systemSymbolName: "camera.viewfinder",
            accessibilityDescription: "ScreenCopy"
        ) {
            image.isTemplate = true
            button.image = image
            button.imagePosition = .imageOnly
            button.title = ""
        } else {
            button.image = nil
            button.title = "SC"
        }

        button.toolTip = isCapturing
            ? "ScreenCopy is waiting for a selection"
            : "Click to capture an area. Right-click for options."
    }

    @objc private func statusItemClicked(_ sender: Any?) {
        let event = NSApp.currentEvent
        let shouldShowMenu = event?.type == .rightMouseUp
            || event?.modifierFlags.contains(.control) == true

        if shouldShowMenu {
            showMenu()
        } else {
            captureController.startCapture()
        }
    }

    @objc private func captureArea(_ sender: Any?) {
        captureController.startCapture()
    }

    @objc private func openScreenRecordingSettings(_ sender: Any?) {
        let settingsURLs = [
            URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"),
            URL(string: "x-apple.systempreferences:com.apple.preference.security")
        ].compactMap { $0 }

        for url in settingsURLs where NSWorkspace.shared.open(url) {
            return
        }
    }

    @objc private func quit(_ sender: Any?) {
        NSApp.terminate(nil)
    }

    private func showMenu() {
        guard let button = statusItem.button else {
            return
        }

        let menu = NSMenu()
        let captureItem = NSMenuItem(
            title: captureController.isCapturing ? "Capturing..." : "Capture Area",
            action: #selector(captureArea(_:)),
            keyEquivalent: ""
        )
        captureItem.target = self
        captureItem.isEnabled = !captureController.isCapturing
        menu.addItem(captureItem)

        let settingsItem = NSMenuItem(
            title: "Screen Recording Settings",
            action: #selector(openScreenRecordingSettings(_:)),
            keyEquivalent: ""
        )
        settingsItem.target = self
        menu.addItem(settingsItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: "Quit ScreenCopy",
            action: #selector(quit(_:)),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        menu.popUp(
            positioning: nil,
            at: NSPoint(x: 0, y: button.bounds.height + 4),
            in: button
        )
    }
}
