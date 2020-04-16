import Foundation

extension Date {
    static func getCurrentTime() -> Double {
        let date = Date()
        return date.timeIntervalSince1970
    }
}
