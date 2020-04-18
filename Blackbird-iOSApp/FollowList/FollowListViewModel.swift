import Foundation

enum FollowListType {
    case following(_ id: String)
    case followers(_ id: String)
}

final class FollowListViewModel {
    private let network = BlackbirdWorker()
    private let followListType: FollowListType
    var users: [User] = []
    var reloadTable: (() -> Void)?

    init(followListType: FollowListType) {
        self.followListType = followListType
    }

    func getList() {
        let completion: (Result<[User], BlackbirdError>) -> Void = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.users = users
                self.reloadTable?()
            case .failure(let error):
                print(error)
            }
        }

        switch followListType {
        case .followers(let id):
            network.followers(userId: id, completion: completion)
        case .following(let id):
            network.following(userId: id, completion: completion)
        }
    }
}
