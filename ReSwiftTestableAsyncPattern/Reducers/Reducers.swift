import ReSwift

func appReducer (action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    switch action {
    case let action as SetFetchUsers:
        state.fetchUsers = action.state
        if case let FetchUsers.success(users) = action.state {
            state.users = users
        }

    case let action as SetFetchPosts:
        state.fetchPosts = action.state
        if case let FetchPosts.success(posts) = action.state {
            state.posts = posts
        }

    default:
        break
    }

    return state
}
