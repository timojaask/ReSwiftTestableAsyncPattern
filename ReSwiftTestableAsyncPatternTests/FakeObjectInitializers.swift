import Foundation

func initialAppState() -> AppState {
    return AppState(
        users: [],
        posts: [],
        fetchUsers: FetchUsers.none,
        fetchPosts: FetchPosts.none,
        createPost: CreatePost.none
    )
}
