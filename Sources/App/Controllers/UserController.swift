import Vapor

final class UsersController {
    func createHandler(_ req: Request) throws -> Future<AppUser> {
        return try req.content.decode(AppUser.self).flatMap { user in
            return user.save(on: req)
        }
    }

    func getAllHandler(_ req: Request) throws -> Future<[UserProfileResponse]> {
        return try flatMap(req.parameters.next(AppUser.self), AppUser.query(on: req).decode(AppUser.self).all()) { currentUser, users in
            var allUsers = users
            if let index = try users.firstIndex(where: { try ($0.requireID() == currentUser.requireID())}) {
                allUsers.remove(at: index)
            }
            var responses = [UserProfileResponse]()
            for user in allUsers {
                responses.append(try UserProfileResponse(user: user))
            }
            return Future.map(on: req) { responses }
        }
    }

    func getOneHandler(_ req: Request) throws -> Future<[AppUser]> {
        let searchParam = try req.query.get(String.self, at: "search")
        return AppUser.query(on: req).filter(\.name, .equal, "%\(searchParam)%").all()
    }

    func followUser(_ req: Request) throws -> Future<SimpleResponse> {
        return try followUserStatus(req).then { status in
            let success = status.code == UInt(bitPattern: 201)
            return Future.map(on: req) {
                SimpleResponse(success: success)
            }
        }
    }

    func followUserStatus(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(AppUser.self), req.parameters.next(AppUser.self)) { currentUser, followUser in
            let pivot = try UserFollowersPivot(currentUser, followUser)
            return pivot.save(on: req).transform(to: .created)
        }
    }

    func unfollowUser(_ req: Request) throws -> Future<SimpleResponse> {
        return try unfollowUserStatus(req).then { status in
            let success = status.code == UInt(bitPattern: 201)
            return Future.map(on: req) {
                SimpleResponse(success: success)
            }
        }
    }

    func unfollowUserStatus(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(AppUser.self), req.parameters.next(AppUser.self)) { currentUser, unfollowUser in
            return currentUser.followings.detach(unfollowUser, on: req).transform(to: .created)
        }
    }

    func followerList(_ req: Request) throws -> Future<[UserProfileResponse]> {
        return try req.parameters.next(AppUser.self).flatMap { user in
            return try user.followers.query(on: req).all().flatMap { followers in
                let userProfiles = try followers.map(UserProfileResponse.init)
                return Future.map(on: req) { return userProfiles }
            }
        }
    }

    func followingListRaw(_ req: Request) throws -> Future<[AppUser]> {
        return try req.parameters.next(AppUser.self).flatMap { user in
            return try user.followings.query(on: req).all()
        }
    }

    func followingList(_ req: Request) throws -> Future<[UserProfileResponse]> {
        return try followingListRaw(req).flatMap { followers in
            let userProfiles = try followers.map(UserProfileResponse.init)
            return Future.map(on: req) { return userProfiles }
        }
    }

    func profile(_ req: Request) throws -> Future<ProfileResponse> {
        return flatMap(try req.parameters.next(AppUser.self), try req.parameters.next(AppUser.self)) { currentUser, userProfile in
            let isCurrentUser = try (currentUser.requireID() == userProfile.requireID())
            return flatMap(try userProfile.followings.query(on: req).count(), try userProfile.followers.query(on: req).count(), try userProfile.tweets.query(on: req).all()) { followingCount, followerCount, tweets in
                if isCurrentUser {
                    return Future.map(on: req) { return try self.profileResponse(user: userProfile, tweets: tweets, followingCount: followingCount, followerCount: followerCount, followUser: false, isCurrentUser: true) }
                } else {
                    return try currentUser.followings.query(on: req).filter(\UserFollowersPivot.followerId, .equal, try userProfile.requireID()).count().flatMap({ isFollowing in
                        return Future.map(on: req) { return try self.profileResponse(user: userProfile, tweets: tweets, followingCount: followingCount, followerCount: followerCount, followUser: isFollowing == 1, isCurrentUser: false) }
                    })
                }
            }
        }
    }

    private func profileResponse(user: AppUser, tweets: [Tweet], followingCount: Int, followerCount: Int, followUser: Bool, isCurrentUser: Bool) throws -> ProfileResponse {
        var responses = [TweetResponse]()
        for tweet in tweets {
            responses.append(try TweetResponse(tweet: tweet, user: user))
        }
        return try ProfileResponse(user: user, followingCount: followingCount, followersCount: followerCount, tweets: responses, followUser: followUser, isCurrentUser: isCurrentUser)
    }
}

extension UsersController: RouteCollection {
    func boot(router: Router) throws {
        let getUsersRoute = router.grouped("api", "users", AppUser.parameter)
        getUsersRoute.get(use: getAllHandler)

        let createUsersRoute = router.grouped("api", "users")
        createUsersRoute.post(use: createHandler)

        let singleUserRoute = router.grouped("api", "user")
        singleUserRoute.get(use: getOneHandler)

        let followUserRoute = router.grouped("api", "follow", AppUser.parameter, AppUser.parameter)
        followUserRoute.post(use: followUser)

        let unfollowUserRoute = router.grouped("api", "unfollow", AppUser.parameter, AppUser.parameter)
        unfollowUserRoute.post(use: unfollowUser)

        let followerListRoute = router.grouped("api", "followers", AppUser.parameter)
        followerListRoute.get(use: followerList)

        let followingListRoute = router.grouped("api", "following", AppUser.parameter)
        followingListRoute.get(use: followingList)

        let profileRoute = router.grouped("api", "profile", AppUser.parameter, AppUser.parameter)
        profileRoute.get(use: profile)
    }
}
