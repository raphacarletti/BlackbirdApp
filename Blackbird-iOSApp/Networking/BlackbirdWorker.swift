import Foundation

final class BlackbirdWorker {
    private let alamofire = AlamofireWrapper.self
    private let userDefaults = UserDefaultsWrapper()

    func authenticate(username: String, password: String, completion: @escaping (Result<AuthenticationResponse, BlackbirdError>) -> Void) {
        let params = AuthenticationParameters(username: username, password: password)
        alamofire.request(.authenticate(params), completion: completion)
    }

    func getFeed(completion: @escaping (Result<[Tweet], BlackbirdError>) -> Void) {
        guard let userId = userDefaults.value(key: .userId, type: String.self) else {
            completion(.failure(.unknown))
            return
        }
        alamofire.request(.feed(userId), completion: completion)
    }

    func postTweet(text: String, completion: @escaping (Result<SimpleResponse, BlackbirdError>) -> Void) {
        guard let userId = userDefaults.value(key: .userId, type: String.self) else {
            completion(.failure(.unknown))
            return
        }
        alamofire.request(.post(userId, text), completion: completion)
    }

    func getProfile(userId: String, completion: @escaping (Result<Profile, BlackbirdError>) -> Void) {
        guard let currentUserId = userDefaults.value(key: .userId, type: String.self) else {
            completion(.failure(.unknown))
            return
        }
        alamofire.request(.profile(currentUserId, userId), completion: completion)
    }

    func followUser(userId: String, completion: @escaping (Result<SimpleResponse, BlackbirdError>) -> Void) {
        guard let currentUserId = userDefaults.value(key: .userId, type: String.self) else {
            completion(.failure(.unknown))
            return
        }
        alamofire.request(.follow(currentUserId, userId), completion: completion)
    }

    func unfollowUser(userId: String, completion: @escaping (Result<SimpleResponse, BlackbirdError>) -> Void) {
        guard let currentUserId = userDefaults.value(key: .userId, type: String.self) else {
            completion(.failure(.unknown))
            return
        }
        alamofire.request(.unfollow(currentUserId, userId), completion: completion)
    }

    func searchUser(completion: @escaping (Result<[User], BlackbirdError>) -> Void) {
        guard let currentUserId = userDefaults.value(key: .userId, type: String.self) else {
            completion(.failure(.unknown))
            return
        }
        alamofire.request(.searchUsers(currentUserId), completion: completion)
    }

    func followers(userId: String, completion: @escaping (Result<[User], BlackbirdError>) -> Void) {
        alamofire.request(.followers(userId), completion: completion)
    }

    func following(userId: String, completion: @escaping (Result<[User], BlackbirdError>) -> Void) {
        alamofire.request(.following(userId), completion: completion)
    }
}
