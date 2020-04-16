import Vapor
import FluentPostgreSQL

final class AppUser: Codable {
    var id: UUID?
    var name: String
    var username: String
    var password: String
    var profileDescription: String

    init(name: String, username: String, password: String, profileDescription: String) {
        self.name = name
        self.username = username
        self.password = password
        self.profileDescription = profileDescription
    }
}

extension AppUser: PostgreSQLUUIDModel {}
extension AppUser: Migration {}
extension AppUser: Content {}
extension AppUser: Parameter {}

// Tweets

extension AppUser {
    var tweets: Children<AppUser, Tweet> {
        return children(\.userId)
    }
}

//Followers

extension AppUser {
    var followers: Siblings<AppUser, AppUser, UserFollowersPivot> {
        return siblings(UserFollowersPivot.rightIDKey, UserFollowersPivot.leftIDKey)
    }

    var followings: Siblings<AppUser, AppUser, UserFollowersPivot> {
        return siblings(UserFollowersPivot.leftIDKey, UserFollowersPivot.rightIDKey)
    }
}
