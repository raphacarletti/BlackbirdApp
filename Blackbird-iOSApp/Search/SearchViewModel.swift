import Foundation

final class SearchViewModel {
    private let network = BlackbirdWorker()
    var users: [User] = []
    var reloadTable: (() -> Void)?

    func getUsers() {
        network.searchUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.users = users
                self.reloadTable?()
            case .failure(let error):
                print(error)
            }
        }
    }
}
