import Cocoa
import Foundation

class FeedbackWindow: NSWindow {
    static let token: String = {
        ""
    }()
    static var shared: FeedbackWindow?
    var issueTitle: TextArea!
    var body: TextArea!
    var sendButton: NSButton!
    var debugProfile: NSButton!
    static var canBecomeKey_ = true
    override var canBecomeKey: Bool { Self.canBecomeKey_ }

    convenience init() {
        self.init(contentRect: .zero, styleMask: [.titled, .miniaturizable, .closable], backing: .buffered, defer: false)
        setupWindow()
        setupView()
        setFrameAutosaveName("FeedbackWindow")
        Self.shared = self
    }

    private func setupWindow() {
        title = NSLocalizedString("Send feedback", comment: "")
        hidesOnDeactivate = false
        isReleasedWhenClosed = false
    }

    private func setupView() {
        let appIcon = LightImageView()
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        appIcon.updateContents(.cgImage(App.appIcon), NSSize(width: 80, height: 80))
        appIcon.fit(80, 80)
        let appText = StackView([
            BoldLabel(NSLocalizedString("Share improvement ideas, or report bugs", comment: "")),
        ], .vertical)
        appText.spacing = GridView.interPadding / 2
        let header = NSStackView(views: [appIcon, appText])
        header.translatesAutoresizingMaskIntoConstraints = false
        header.spacing = GridView.interPadding
        sendButton = NSButton(title: NSLocalizedString("Send", comment: ""), target: nil, action: #selector(sendCallback))
        sendButton.keyEquivalent = "\r"
        let buttons = StackView([
            NSButton(title: NSLocalizedString("Cancel", comment: ""), target: nil, action: #selector(cancel)),
            sendButton,
        ])
        buttons.spacing = GridView.interPadding
        issueTitle = TextArea(80, 1, NSLocalizedString("Title", comment: ""), checkEmptyFields)
        body = TextArea(80, 12, NSLocalizedString("I think the app could be improved with…", comment: ""), checkEmptyFields)
        debugProfile = NSButton(checkboxWithTitle: NSLocalizedString("Send debug profile (CPU, memory, etc)", comment: ""), target: nil, action: nil)
        debugProfile.state = .on
        let warning = BoldLabel(NSLocalizedString("Feedback submission is disabled in this local build.", comment: ""))
        let view = GridView([
            [header],
            [NSView()],
            [warning],
            [issueTitle],
            [body],
            [debugProfile],
            [buttons],
        ])
        view.cell(atColumnIndex: 0, rowIndex: 6).xPlacement = .trailing
        setContentSize(view.fittingSize)
        contentView = view
        checkEmptyFields()
    }

    private func checkEmptyFields() {
        sendButton.isEnabled = !body.stringValue.isEmpty && !issueTitle.stringValue.isEmpty
        sendButton.toolTip = sendButton.isEnabled ? "" : NSLocalizedString("Please fill in the form", comment: "")
    }

    // allow to close with the escape key
    @objc func cancel(_ sender: Any?) {
        close()
    }

    @objc private func sendCallback() {
        Logger.info { "Feedback submission is disabled in this local build" }
        issueTitle.stringValue = ""
        body.stringValue = ""
        close()
    }

    override func close() {
        hideAppIfLastWindowIsClosed()
        super.close()
    }
}
