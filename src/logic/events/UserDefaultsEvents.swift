import Cocoa

class UserDefaultsEvents: NSObject {
    private static var policyObserver = UserDefaultsEvents()
    private static var isObserving = false

    static func observe() {
        guard !isObserving else { return }
        isObserving = true
        UserDefaults.standard.addObserver(policyObserver, forKeyPath: "SUAutomaticallyUpdate", options: [.initial, .new], context: nil)
        UserDefaults.standard.addObserver(policyObserver, forKeyPath: "SUEnableAutomaticChecks", options: [.initial, .new], context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        handleEvent(keyPath)
    }

    private func handleEvent(_ keyPath: String?) {
        Logger.debug { "\(keyPath ?? "keyPath:nil") updatePolicy:\(Preferences.updatePolicy) policyLock:\(GeneralTab.policyLock)" }
        guard !GeneralTab.policyLock else { return }
        let id = buttonIdToUpdate()
        GeneralTab.updatesPolicyDropdown?.selectItem(at: id)
        Preferences.set("updatePolicy", String(id))
    }

    private func buttonIdToUpdate() -> Int {
        if UserDefaults.standard.bool(forKey: "SUAutomaticallyUpdate") {
            return 2
        } else if UserDefaults.standard.bool(forKey: "SUEnableAutomaticChecks") {
            return 1
        }
        return 0
    }
}
