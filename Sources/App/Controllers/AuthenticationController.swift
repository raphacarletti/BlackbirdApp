import Vapor

final class AuthenticationController {
    func authenticationHandler(req: Request) throws -> Future<SimpleResponse> {
        return try req.content.decode(Authentication.self).flatMap { authentication in
            let userCount = AppUser.query(on: req)
                .filter(\.username, .equal, authentication.username)
                .filter(\.password, .equal, authentication.password)
                .count()

            return userCount.flatMap({ count -> EventLoopFuture<SimpleResponse> in
                let success = count == 1
                return req.response().future(SimpleResponse(success: success))
            })
        }
    }
}

extension AuthenticationController: RouteCollection {
    func boot(router: Router) throws {
        let route = router.grouped("api", "authentication")
        route.post(use: authenticationHandler)
    }
}
