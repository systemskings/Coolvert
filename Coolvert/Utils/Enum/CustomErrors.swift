import Foundation

enum CustomErrors: LocalizedError {
    case emailNotVerified

    var errorDescription: String? {
        switch self {
        case .emailNotVerified:
            return "E-mail não verificado"
        }
    }
}
