import Vapor

final class SimpleResponse: Codable, Content {
    let success: Bool

    init(success: Bool) {
        self.success = success
    }
}
