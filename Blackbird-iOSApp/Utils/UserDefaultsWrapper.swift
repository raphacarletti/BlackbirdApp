import Foundation

final class UserDefaultsWrapper {
    enum Keys {
        case userId

        var keyValue: String {
            switch self {
            case .userId:
                return "user_id"
            }
        }
    }

    private let userDefault = UserDefaults.standard

    func value<T>(key: Keys, type: T.Type) -> T? {
        return userDefault.value(forKey: key.keyValue) as? T
    }

    func set(value: Any?, key: Keys) {
        userDefault.set(value, forKey: key.keyValue)
    }
}
