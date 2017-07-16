import ReSwift

enum FetchUsers {
    case none
    case request
    case success(users: [User])
    case error(error: Error)
}

struct SetFetchUsers: Action {
    let state: FetchUsers
}
