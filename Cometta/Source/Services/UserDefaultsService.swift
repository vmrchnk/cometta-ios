import Foundation

// MARK: - User Defaults Service
final class UserDefaultsService {
    static let shared = UserDefaultsService()

    private let defaults = UserDefaults.standard

    private init() {}

    // MARK: - Keys
    private enum Keys {
        static let userId = "userId"
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }

    // MARK: - User ID
    var userId: String? {
        get {
            defaults.string(forKey: Keys.userId)
        }
        set {
            defaults.set(newValue, forKey: Keys.userId)
        }
    }

    // MARK: - Onboarding
    var hasSeenOnboarding: Bool {
        get {
            defaults.bool(forKey: Keys.hasSeenOnboarding)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasSeenOnboarding)
        }
    }

    // MARK: - Clear
    func clearAll() {
        defaults.removeObject(forKey: Keys.userId)
        defaults.removeObject(forKey: Keys.hasSeenOnboarding)
    }
}
