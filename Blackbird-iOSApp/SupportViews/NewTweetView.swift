import UIKit
import Cartography

protocol NewTweetViewDelegate: AnyObject {
    func post(text: String)
}

final class NewTweetView: UIView {
    private let textView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        return view
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
        return button
    }()

    weak var delegate: NewTweetViewDelegate?

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    private func setup() {
        backgroundColor = .white
        
        addSubview(textView)
        addSubview(button)

        constrain(self, textView, button) { superview, textView, button in
            textView.top == superview.top + 4
            textView.leading == superview.leading + 8
            textView.trailing == superview.trailing - 8
            textView.height == 100

            button.top == textView.bottom + 2
            button.trailing == superview.trailing - 4
            button.bottom == superview.bottom - 8
        }
    }

    @objc
    private func didTapPost() {
        delegate?.post(text: textView.text)
    }
}
