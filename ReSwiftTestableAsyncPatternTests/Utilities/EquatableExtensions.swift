import Foundation
import ReSwift

extension FetchUsersState: Equatable { }

func ==(lhs: FetchUsersState, rhs: FetchUsersState) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
        return true
    case (.request, .request):
        return true
    case let (.success(lhsVal), .success(rhsVal)):
        return lhsVal == rhsVal
    case let (.error(lhsVal), .error(rhsVal)):
        return lhsVal == rhsVal
    default:
        return false
    }
}

extension Error where Self: Equatable { }

func ==(lhs: Error, rhs: Error) -> Bool {
    return lhs.localizedDescription == rhs.localizedDescription &&
        lhs.isCancelledError == rhs.isCancelledError
}

extension SetFetchUsersState: Equatable { }

func ==(lhs: SetFetchUsersState, rhs: SetFetchUsersState) -> Bool {
    return lhs.state == rhs.state
}

extension Action where Self: Equatable {

}

func ==(lhs: Action, rhs: Action) -> Bool {
    return lhs == rhs
}

extension User: Equatable { }

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName
}
