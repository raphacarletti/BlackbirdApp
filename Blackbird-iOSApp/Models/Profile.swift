import Foundation

struct Profile: Codable {
    let id: String
    let name: String
    let username: String
    let description: String
    let followingCount: Int
    let followersCount: Int
    let tweets: [Tweet]
    let isCurrentUser: Bool
    let followUser: Bool
}
