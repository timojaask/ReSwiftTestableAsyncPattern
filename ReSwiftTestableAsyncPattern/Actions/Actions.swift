import ReSwift

enum FetchUsers {
    case none
    case request
    case success(users: [User])
    case error(error: Error)
}

enum FetchPosts {
    case none
    case request
    case success(posts: [Post])
    case error(error: Error)
}

struct SetFetchUsers: Action { let state: FetchUsers }
struct SetFetchPosts: Action { let state: FetchPosts }
