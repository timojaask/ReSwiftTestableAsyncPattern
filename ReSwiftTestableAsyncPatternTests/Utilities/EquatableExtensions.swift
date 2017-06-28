import Foundation
import ReSwift

extension FetchDataState: Equatable { }

func ==(lhs: FetchDataState, rhs: FetchDataState) -> Bool {
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

extension Error where Self: Equatable {

}

func ==(lhs: Error, rhs: Error) -> Bool {
    return lhs.localizedDescription == rhs.localizedDescription &&
        lhs.isCancelledError == rhs.isCancelledError
}

extension SetFetchDataState: Equatable { }

func ==(lhs: SetFetchDataState, rhs: SetFetchDataState) -> Bool {
    return lhs.state == rhs.state
}

extension Action where Self: Equatable {

}

func ==(lhs: Action, rhs: Action) -> Bool {
    return lhs == rhs
}
