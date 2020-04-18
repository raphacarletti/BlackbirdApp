import Vapor

final class ProfileResponse: Content {
    let id: UUID?
    let name: String
    let username: String
    let description: String
    let followingCount: Int
    let followersCount: Int
    let followUser: Bool
    let isCurrentUser: Bool
    let tweets: [TweetResponse]

    init(user: AppUser, followingCount: Int = 0, followersCount: Int = 0, tweets: [TweetResponse], followUser: Bool, isCurrentUser: Bool) throws {
        self.id = try user.requireID()
        self.name = user.name
        self.username = user.username
        self.description = user.profileDescription
        self.followingCount = followingCount
        self.followersCount = followersCount
        self.tweets = tweets
        self.followUser = followUser
        self.isCurrentUser = isCurrentUser
    }
}
