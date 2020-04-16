import Vapor

public func routes(_ router: Router) throws {
    let usersController = UsersController()
    try router.register(collection: usersController)

    let authenticationController = AuthenticationController()
    try router.register(collection: authenticationController)

    let tweetController = TweetController()
    try router.register(collection: tweetController)
}
