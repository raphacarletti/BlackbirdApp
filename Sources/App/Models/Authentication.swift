import Vapor

struct Authentication: Codable {
    let username: String
    let password: String
}
