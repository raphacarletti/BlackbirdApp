import Vapor

final class UserProfileResponse: Content {
    var id: UUID
    var name: String
    var username: String
    var profileDescription: String

    init(user: AppUser) throws {
        self.name = user.name
        self.id = try user.requireID()
        self.username = user.username
        self.profileDescription = user.profileDescription
    }
}
