import Foundation

func initialAppState() -> AppState {
    return AppState(users: [], fetchUsersState: .none)
}
