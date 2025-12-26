import ComposableArchitecture
import Foundation

// MARK: - User Client
struct UserClient {
    var loadUser: () -> User?
    var saveUser: (User) throws -> Void
    var deleteUser: () throws -> Void
}

// MARK: - Dependency Key
extension UserClient: DependencyKey {
    
    enum Constant {
        static var fileName = "user.json"
    }
    static let liveValue = Self(
        loadUser: {
            try? StorageHelper.load(User.self, from: Constant.fileName)
        },
        saveUser: { user in
            try StorageHelper.save(user, to:  Constant.fileName)
        },
        deleteUser: {
            try StorageHelper.delete(Constant.fileName)
        }
    )
    
    static let previewValue = Self(
        loadUser: { 
            // Return a mock user for preview if needed
            return nil
        },
        saveUser: { _ in },
        deleteUser: { }
    )
}

// MARK: - Dependency Values Extension
extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
