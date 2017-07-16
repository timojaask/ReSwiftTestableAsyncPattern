import ReSwift

struct AppState: StateType {
    var users: [User] = []
    var posts: [Post] = []
    var fetchUsers = FetchUsers.none
    var fetchPosts = FetchPosts.none
    var createPost = CreatePost.none
}
