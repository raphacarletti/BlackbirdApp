import Vapor
import FluentPostgreSQL

final class Tweet: Codable {
    var id: UUID?
    var message: String
    var userId: AppUser.ID
    var timestamp: Double

    init(message: String, userId: AppUser.ID, timestamp: Double) {
        self.message = message
        self.userId = userId
        self.timestamp = timestamp
    }
}

extension Tweet: PostgreSQLUUIDModel {}
extension Tweet: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return Database.create(self, on: connection) { (builder) in
            try addProperties(to: builder)
            builder.reference(from: \.userId, to: \AppUser.id)
        }
    }
}
extension Tweet: Content {}
extension Tweet: Parameter {}

extension Tweet {
    var userParent: Parent<Tweet, AppUser> {
        return parent(\.userId)
    }
}
