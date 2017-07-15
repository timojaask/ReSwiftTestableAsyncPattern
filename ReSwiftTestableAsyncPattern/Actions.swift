import ReSwift

enum FetchUsersState {
    case none
    case request
    case success(users: [User])
    case error(error: Error)
}

struct SetFetchUsersState: Action {
    let state: FetchUsersState
}
