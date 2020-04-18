import Vapor

final class AuthenticationResponse: Codable, Content {
    let userId: String

    init(userId: String) {
        self.userId = userId
    }
}
