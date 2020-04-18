import Foundation

final class LoginViewModel {
    private let network = BlackbirdWorker()
    private let userDefaults = UserDefaultsWrapper()
    var authenticated: (() -> Void)?

    func authenticate(username: String, password: String) {
        network.authenticate(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let response):
                self?.userDefaults.set(value: response.userId, key: .userId)
                self?.authenticated?()
            case .failure(let error):
                print(error)
            }
        }
    }
}
