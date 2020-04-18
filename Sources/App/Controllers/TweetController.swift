import Vapor

final class TweetController {
    func createHandler(_ req: Request) throws -> Future<SimpleResponse> {
        return try req.parameters.next(AppUser.self).flatMap({ user -> EventLoopFuture<SimpleResponse> in
            return try req.content.decode(CreateTweetRequest.self).flatMap({ createTweet in
                let tweet = try Tweet(message: createTweet.message, userId: user.requireID(), timestamp: Date.getCurrentTime())
                let _ = tweet.save(on: req)
                return req.response().future(SimpleResponse(success: true))
            })
        })
    }

    func getFeed(_ req: Request) throws -> Future<[TweetResponse]> {
        return try req.parameters.next(AppUser.self).flatMap({ user in
            try flatMap(
                user.tweets.query(on: req).all(),
                Tweet.query(on: req)
                    .join(\AppUser.id, to: \Tweet.userId)
                    .alsoDecode(AppUser.self)
                    .join(\UserFollowersPivot.followerId, to: \AppUser.id)
                    .filter(\UserFollowersPivot.followedId, .equal, user.requireID())
                    .all()) { myTweets, followingTweets in
                        var responses = [TweetResponse]()
                        for tweet in myTweets {
                            responses.append(try TweetResponse(tweet: tweet, user: user))
                        }
                        for (tweet, user) in followingTweets {
                            responses.append(try TweetResponse(tweet: tweet, user: user))
                        }

                        responses.sort { first, second in
                            let firstTweetDate = Date(timeIntervalSince1970: first.timestamp)
                            let secondTweetDate = Date(timeIntervalSince1970: second.timestamp)
                            if firstTweetDate > secondTweetDate {
                                return true
                            }
                            return false
                        }

                        return Future.map(on: req) { return responses }
            }
        })
    }
}

extension TweetController: RouteCollection {
    func boot(router: Router) throws {
        let createTweetRoute = router.grouped("api", "tweet", AppUser.parameter)
        createTweetRoute.post(use: createHandler)

        let feedRoute = router.grouped("api", "feed", AppUser.parameter)
        feedRoute.get(use: getFeed)
    }
}
