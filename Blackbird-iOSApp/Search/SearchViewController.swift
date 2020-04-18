import UIKit

final class SearchViewController: UIViewController {
    private lazy var customView = SearchView(dataSourceDelegate: self)
    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reloadTable = {
            self.customView.reloadTable()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUsers()
    }

    override func loadView() {
        view = customView
    }

    private func goToProfile(userId: String) {
        let vc = ProfileViewController(profileType: .user(userId))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchUserCell.self), for: indexPath) as? SearchUserCell else { return UITableViewCell() }
        let user = viewModel.users[indexPath.row]
        cell.configure(user: user)
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.row]
        goToProfile(userId: user.id)
    }
}
