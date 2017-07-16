import ReSwift

enum FetchUsers {
    case none
    case request
    case loading
    case success(users: [User])
    case error(error: Error)
}

enum FetchPosts {
    case none
    case request
    case loading
    case success(posts: [Post])
    case error(error: Error)
}

enum CreatePost {
    case none
    case request(post: Post)
    case loading
    case success()
    case error(error: Error)
}

struct SetFetchUsers: Action { let state: FetchUsers }
struct SetFetchPosts: Action { let state: FetchPosts }
struct SetCreatePost: Action { let state: CreatePost }
