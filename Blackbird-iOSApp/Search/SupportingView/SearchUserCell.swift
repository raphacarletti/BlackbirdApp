import UIKit
import Cartography

final class SearchUserCell: UITableViewCell {
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        return label
    }()

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(usernameLabel)
        return stackView
    }()

    var user: User?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    private func setup() {
        addSubview(titleStackView)

        constrain(self, titleStackView) { superview, stackView in
            stackView.top == superview.top + 4
            stackView.leading == superview.leading + 8
            stackView.trailing <= superview.trailing - 8
            stackView.bottom == superview.bottom - 4
        }
    }

    func configure(user: User) {
        self.user = user
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.username)"
    }
}
