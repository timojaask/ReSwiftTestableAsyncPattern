import ReSwift

func appReducer (action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    switch action {
    case let action as SetFetchDataState:
        state.fetchDataState = action.state
        if case let FetchDataState.success(data) = action.state {
            state.remoteData = data
        }

    default:
        break
    }

    return state
}
