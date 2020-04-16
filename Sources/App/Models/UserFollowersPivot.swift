import Vapor
import FluentPostgreSQL

final class UserFollowersPivot: PostgreSQLPivot, ModifiablePivot {
    var id: Int?
    var followerId: AppUser.ID
    var followedId: AppUser.ID

    typealias Left = AppUser
    typealias Right = AppUser

    static var rightIDKey: WritableKeyPath<UserFollowersPivot, UserFollowersPivot.Right.ID> {
        return \.followerId
    }

    static var leftIDKey: WritableKeyPath<UserFollowersPivot, UserFollowersPivot.Left.ID> {
        return \.followedId
    }

    init(_ follower: AppUser, _ followed: AppUser) throws {
        self.followerId = try follower.requireID()
        self.followedId = try followed.requireID()
    }
}

extension UserFollowersPivot: Migration {}
