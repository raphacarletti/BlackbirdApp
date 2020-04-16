import Vapor

final class CreateTweetRequest: Codable {
    let message: String

    init(message: String) {
        self.message = message
    }
}
