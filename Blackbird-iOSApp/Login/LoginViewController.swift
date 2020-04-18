import UIKit

class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        viewModel.authenticated = { [weak self] in
            self?.goToFeed()
        }
    }

    override func loadView() {
        let customView = LoginView()
        customView.delegate = self
        view = customView
    }

    private func goToFeed() {
        let vc = TabBarController()
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.viewControllers.removeAll(where: { $0 == self })
    }
}

extension LoginViewController: LoginViewDelegate {
    func didTapLogin(username: String, password: String) {
        viewModel.authenticate(username: username, password: password)
    }
}

