import UIKit
import Cartography

protocol LoginViewDelegate: AnyObject {
    func didTapLogin(username: String, password: String)
}

final class LoginView: UIView {
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.placeholder = "Username"
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        return stackView
    }()

    weak var delegate: LoginViewDelegate?

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

        addSubview(stackView)
        constrain(self, stackView) { superview, stackView in
            stackView.center == superview.center
            stackView.leading == superview.leading + 16
            stackView.trailing == superview.trailing - 16
        }
    }

    @objc
    private func didTapLogin() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        delegate?.didTapLogin(username: username, password: password)
    }
}
