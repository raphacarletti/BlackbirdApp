import UIKit

final class FollowListViewController: UIViewController {
    private let viewModel: FollowListViewModel
    private lazy var customView = FollowListView(dataSourceDelegate: self)

    init(followListType: FollowListType) {
        self.viewModel = FollowListViewModel(followListType: followListType)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reloadTable = {
            self.customView.reloadTable()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getList()
    }

    private func goToProfile(userId: String) {
        let vc = ProfileViewController(profileType: .user(userId))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FollowListViewController: UITableViewDataSource {
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

extension FollowListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.row]
        goToProfile(userId: user.id)
    }
}
