import UIKit
import Cartography

protocol ProfileViewDelegate: AnyObject {
    func follow()
    func unfollow()
    func didTapFollowers()
    func didTapFollowing()
}

final class ProfileView: UIView {
    private lazy var profileView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        view.delegate = self
        return view
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(TweetCell.self, forCellReuseIdentifier: String(describing: TweetCell.self))
        return view
    }()

    weak var delegate: ProfileViewDelegate?

    init(dataSourceDelegate: UITableViewDataSource) {
        super.init(frame: .zero)

        tableView.dataSource = dataSourceDelegate 

        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    private func setup() {
        backgroundColor = .white

        addSubview(profileView)
        addSubview(tableView)

        constrain(self, profileView, tableView) { superview, profileView, tableView in
            profileView.topMargin == superview.topMargin
            profileView.leading == superview.leading
            profileView.trailing == superview.trailing

            tableView.top == profileView.bottom
            tableView.leading == superview.leading
            tableView.trailing == superview.trailing
            tableView.bottom == superview.bottom
        }
    }


    func configure(with profile: Profile) {
        profileView.configure(with: profile)
        tableView.reloadData()
    }
}


extension ProfileView: ProfileHeaderViewDelegate {
    func follow() {
        delegate?.follow()
    }

    func unfollow() {
        delegate?.unfollow()
    }

    func didTapFollowers() {
        delegate?.didTapFollowers()
    }

    func didTapFollowing() {
        delegate?.didTapFollowing()
    }
}
