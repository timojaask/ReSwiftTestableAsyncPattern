import ReSwift

func appReducer (action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    switch action {
    case let action as SetFetchUsers:
        state.fetchUsers = action.state
        if case let FetchUsers.success(users) = action.state {
            state.users = users
        }

    default:
        break
    }

    return state
}
