import ReSwift

func appReducer (action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    switch action {
    case let action as SetFetchUsersState:
        state.fetchUsersState = action.state
        if case let FetchUsersState.success(users) = action.state {
            state.users = users
        }

    default:
        break
    }

    return state
}
