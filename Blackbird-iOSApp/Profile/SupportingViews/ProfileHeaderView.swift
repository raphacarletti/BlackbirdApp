import UIKit
import Cartography

protocol ProfileHeaderViewDelegate: AnyObject {
    func unfollow()
    func follow()
    func didTapFollowing()
    func didTapFollowers()
}

final class ProfileHeaderView: UIView {
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()

    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.text = "Followers"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFollowers)))
        return label
    }()

    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.text = "Following"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFollowing)))
        return label
    }()

    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private lazy var followStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(followingLabel)
        stackView.addArrangedSubview(followersLabel)
        stackView.addArrangedSubview(followButton)
        return stackView
    }()

    private lazy var profileStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(followStack)
        return stackView
    }()

    weak var delegate: ProfileHeaderViewDelegate?

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    private func setup() {
        addSubview(profileStack)

        constrain(self, profileStack) { superview, profile in
            profile.topMargin == superview.topMargin + 8
            profile.leading == superview.leading + 8
            profile.trailing == superview.trailing - 8
            profile.bottomMargin == superview.bottomMargin - 8
        }
    }

    func configure(with profile: Profile) {
        nameLabel.text = profile.name
        usernameLabel.text = "@\(profile.username)"
        descriptionLabel.text = profile.description
        followersLabel.text = "\(profile.followersCount) Followers"
        followingLabel.text =  "\(profile.followingCount) Following"
        configFollowButton(isCurrentUser: profile.isCurrentUser, followUser: profile.followUser)
    }

    private func configFollowButton(isCurrentUser: Bool, followUser: Bool) {
        if isCurrentUser {
            followButton.isHidden = true
        } else if followUser {
            followButton.setTitle("Unfollow", for: .normal)
            followButton.removeTarget(self, action: #selector(follow), for: .touchUpInside)
            followButton.addTarget(self, action: #selector(unfollow), for: .touchUpInside)
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.removeTarget(self, action: #selector(unfollow), for: .touchUpInside)
            followButton.addTarget(self, action: #selector(follow), for: .touchUpInside)
        }
    }

    @objc
    private func unfollow() {
        delegate?.unfollow()
    }

    @objc
    private func follow() {
        delegate?.follow()
    }

    @objc
    private func didTapFollowing() {
        delegate?.didTapFollowing()
    }

    @objc
    private func didTapFollowers() {
        delegate?.didTapFollowers()
    }
}
