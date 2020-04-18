import Foundation
import Alamofire

enum BlackbirdRequest {
    case authenticate(_ parameters: AuthenticationParameters)
    case feed(_ id: String)
    case post(_ id: String, _ text: String)
    case profile(_ currentUserId: String, _ profileId: String)
    case follow(_ currentUserId: String, _ profileId: String)
    case unfollow(_ currentUserId: String, _ profileId: String)
    case searchUsers(_ id: String)
    case followers(_ id: String)
    case following(_ id: String)

    var urlString: String {
        let baseUrl = "http://localhost:8080/api/"
        let path: String

        switch self {
        case .authenticate:
            path = "authentication"
        case .feed(let id):
            path = "feed/\(id)"
        case .post(let id, _):
            path = "tweet/\(id)"
        case .profile(let currentId, let profileId):
            path = "profile/\(currentId)/\(profileId)"
        case .follow(let currentId, let profileId):
            path = "follow/\(currentId)/\(profileId)"
        case .unfollow(let currentId, let profileId):
            path = "unfollow/\(currentId)/\(profileId)"
        case .searchUsers(let id):
            path = "users/\(id)"
        case .followers(let id):
            path = "followers/\(id)"
        case .following(let id):
            path = "following/\(id)"
        }

        return baseUrl + path
    }

    var method: HTTPMethod {
        switch self {
        case .authenticate, .post, .follow, .unfollow:
            return .post
        case .feed, .profile, .searchUsers, .followers, .following:
            return .get
        }
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var parameters: Parameters? {
        var params: Parameters = [:]

        switch self {
        case .authenticate(let authenticationParams):
            params["username"] = authenticationParams.username
            params["password"] = authenticationParams.password
        case .post(_, let text):
            params["message"] = text
        case .feed, .profile, .follow, .unfollow, .searchUsers, .following, .followers:
            return nil
        }

        return params
    }
}

enum BlackbirdError: Error {
    case unknown

    var localizedDescription: String {
        switch self {
        case .unknown:
            return "Erro desconhecido"
        }
    }
}
