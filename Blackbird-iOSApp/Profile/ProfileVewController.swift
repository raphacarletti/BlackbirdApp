import UIKit

final class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel
    private lazy var customView = ProfileView(dataSourceDelegate: self)
    
    init(profileType: ProfileType) {
        self.viewModel = ProfileViewModel(profileType: profileType)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        viewModel.showProfile = { [weak self] profile in
            guard let self = self else { return }
            self.customView.configure(with: profile)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProfile()
    }

    override func loadView() {
        customView.delegate = self
        view = customView
    }

    func goToFollowList(listType: FollowListType) {
        let vc = FollowListViewController(followListType: listType)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: ProfileViewDelegate {
    func follow() {
        viewModel.followUser()
    }

    func unfollow() {
        viewModel.unfollowUser()
    }

    func didTapFollowing() {
        goToFollowList(listType: .following(viewModel.userId))
    }

    func didTapFollowers() {
        goToFollowList(listType: .followers(viewModel.userId))
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.profile?.tweets.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TweetCell.self), for: indexPath) as? TweetCell,
            let tweet = viewModel.profile?.tweets[indexPath.row] else { return UITableViewCell() }
        cell.configure(tweet: tweet)
        return cell
    }
}
