import UIKit
import Cartography

final class TweetCell: UITableViewCell {
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        return label
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(usernameLabel)
        return stackView
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    var tweet: Tweet?

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
        addSubview(messageLabel)
        addSubview(dateLabel)

        constrain(self, titleStackView, messageLabel, dateLabel) { superview, stackView, message, date in
            stackView.top == superview.top + 4
            stackView.leading == superview.leading + 8
            stackView.trailing <= superview.trailing - 8

            message.top == stackView.bottom + 4
            message.leading == superview.leading + 8
            message.trailing == superview.trailing - 8

            date.top == message.bottom + 2
            date.trailing == superview.trailing - 4
            date.bottom == superview.bottom - 8
        }
    }

    func configure(tweet: Tweet) {
        self.tweet = tweet
        nameLabel.text = tweet.name
        usernameLabel.text = "@\(tweet.username)"
        messageLabel.text = tweet.message
        dateLabel.text = Date.tweetDate(timestamp: tweet.timestamp)
    }
}
