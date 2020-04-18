import Foundation

enum ProfileType {
    case loggedUser
    case user(_ id: String)
}

final class ProfileViewModel {
    private let network = BlackbirdWorker()
    private let profileType: ProfileType
    var profile: Profile?
    var showProfile: ((Profile) -> Void)?

    var userId: String {
        switch profileType {
        case .loggedUser:
            return UserDefaultsWrapper().value(key: .userId, type: String.self) ?? ""
        case .user(let id):
            return id
        }
    }

    init(profileType: ProfileType) {
        self.profileType = profileType
    }

    func getProfile() {
        network.getProfile(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                self.showProfile?(profile)
            case .failure(let error):
                print(error)
            }
        }
    }

    func followUser() {
        network.followUser(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.getProfile()
            case .failure(let error):
                print(error)
            }
        }
    }

    func unfollowUser() {
        network.unfollowUser(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.getProfile()
            case .failure(let error):
                print(error)
            }
        }
    }
}
