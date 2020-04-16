import Vapor

enum ErrorCodes: String {
    case generic = "GENERIC"
    case authenticationFailed = "AUTHENTICATION-FAILED"
}

final class ErrorResponse: Content {
    let errorCode: String
}
