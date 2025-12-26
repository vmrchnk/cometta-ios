import ComposableArchitecture
import Foundation

// MARK: - User Defaults Client
struct UserDefaultsClient {
    var userId: () -> String?
    var setUserId: (String?) -> Void
    var hasSeenOnboarding: () -> Bool
    var setHasSeenOnboarding: (Bool) -> Void
    var clearAll: () -> Void
}

// MARK: - Dependency Key
extension UserDefaultsClient: DependencyKey {
    static let liveValue = Self(
        userId: {
            UserDefaults.standard.string(forKey: Keys.userId)
        },
        setUserId: { newValue in
            if let newValue {
                UserDefaults.standard.set(newValue, forKey: Keys.userId)
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.userId)
            }
        },
        hasSeenOnboarding: {
            UserDefaults.standard.bool(forKey: Keys.hasSeenOnboarding)
        },
        setHasSeenOnboarding: { newValue in
            UserDefaults.standard.set(newValue, forKey: Keys.hasSeenOnboarding)
        },
        clearAll: {
            UserDefaults.standard.removeObject(forKey: Keys.userId)
            UserDefaults.standard.removeObject(forKey: Keys.hasSeenOnboarding)
        }
    )

    static let testValue = Self(
        userId: { nil },
        setUserId: { _ in },
        hasSeenOnboarding: { false },
        setHasSeenOnboarding: { _ in },
        clearAll: { }
    )
    
    static let previewValue = Self(
        userId: { "local_idx" },
        setUserId: { _ in },
        hasSeenOnboarding: { true },
        setHasSeenOnboarding: { _ in },
        clearAll: { }
    )
    
    // Private keys to keep avoiding magic strings
    private enum Keys {
        static let userId = "userId"
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }
}

// MARK: - Dependency Extensions
extension DependencyValues {
    var userDefaults: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}
