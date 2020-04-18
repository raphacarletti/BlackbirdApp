import Foundation

struct Tweet: Codable {
    let username: String
    let name: String
    let id: String
    let message: String
    let timestamp: Double
    let userId: String
}
