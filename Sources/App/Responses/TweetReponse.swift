import Vapor

final class TweetResponse: Content {
    let id: UUID?
    let userId: UUID?
    let username: String
    let name: String
    let message: String
    let timestamp: Double

    init(id: UUID?, userId: UUID?, username: String, name: String, message: String, timestamp: Double) {
        self.id = id
        self.userId = userId
        self.username = username
        self.name = name
        self.message = message
        self.timestamp = timestamp
    }

    init(tweet: Tweet, user: AppUser) throws {
        self.id = try tweet.requireID()
        self.userId = try user.requireID()
        self.username = user.username
        self.name = user.name
        self.message = tweet.message
        self.timestamp = tweet.timestamp
    }
}
