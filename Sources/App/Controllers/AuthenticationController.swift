import Vapor

final class AuthenticationController {
    func authenticationHandler(req: Request) throws -> Future<AuthenticationResponse> {
        return try req.content.decode(Authentication.self).flatMap { authentication in
            let user = AppUser.query(on: req)
                .filter(\.username, .equal, authentication.username)
                .filter(\.password, .equal, authentication.password)
                .first()

            return user.flatMap({ userQuery -> EventLoopFuture<AuthenticationResponse> in
                guard let userUnwrap = userQuery else {
                    throw Abort(.notFound)
                }
                let userId = try userUnwrap.requireID().uuidString
                return req.response().future(AuthenticationResponse(userId: userId))
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
