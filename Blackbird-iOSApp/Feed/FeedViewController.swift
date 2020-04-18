import UIKit

final class FeedViewController: UIViewController {
    private lazy var customView = FeedView(dataSourceDelegate: self)
    private let viewModel = FeedViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reloadTable = { [weak self] in
            guard let self = self else { return }
            self.customView.stopLoading()
            self.customView.reloadTable()
        }
        customView.startLoading()
    }

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           viewModel.getFeed()
       }

    override func loadView() {
        customView.delegate = self
        view = customView
    }


    private func goToProfile(userId: String) {
        let vc = ProfileViewController(profileType: .user(userId))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TweetCell.self), for: indexPath) as? TweetCell else { return UITableViewCell() }
        let tweet = viewModel.tweets[indexPath.row]
        cell.configure(tweet: tweet)
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tweet = viewModel.tweets[indexPath.row]
        goToProfile(userId: tweet.userId)
    }
}

extension FeedViewController: FeedViewDelegate {
    func pullToRefresh() {
        viewModel.getFeed()
    }

    func post(text: String) {
        viewModel.post(text: text)
    }
}
