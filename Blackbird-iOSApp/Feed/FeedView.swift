import UIKit
import Cartography
import JGProgressHUD

protocol FeedViewDelegate: AnyObject {
    func pullToRefresh()
    func post(text: String)
}

final class FeedView: UIView {
    private let activityIndicator = JGProgressHUD(style: .light)
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return control
    }()

    private lazy var newTweetView: NewTweetView = {
        let view = NewTweetView()
        view.delegate = self
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.refreshControl = refreshControl
        tableView.register(TweetCell.self, forCellReuseIdentifier: String(describing: TweetCell.self))
        return tableView
    }()

    weak var delegate: FeedViewDelegate?

    init(dataSourceDelegate: UITableViewDataSource & UITableViewDelegate) {
        super.init(frame: .zero)

        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate

        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    private func setup() {
        backgroundColor = .white

        addSubview(newTweetView)
        addSubview(tableView)

        constrain(self, newTweetView, tableView) { superview, newTweetView, tableView in
            newTweetView.top == superview.topMargin
            newTweetView.leading == superview.leading
            newTweetView.trailing == superview.trailing

            tableView.top == newTweetView.bottom
            tableView.leading == superview.leading
            tableView.trailing == superview.trailing
            tableView.bottom == superview.bottomMargin
        }
    }

    func reloadTable() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }

    @objc
    private func pullToRefresh() {
        delegate?.pullToRefresh()
    }

    func startLoading() {
        activityIndicator.show(in: self)
    }

    func stopLoading() {
        activityIndicator.removeFromSuperview()
    }
}

extension FeedView: NewTweetViewDelegate {
    func post(text: String) {
        delegate?.post(text: text)
    }
}
