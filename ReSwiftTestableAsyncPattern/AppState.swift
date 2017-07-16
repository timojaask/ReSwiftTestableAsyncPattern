import ReSwift

struct AppState: StateType {
    var users: [User] = []
    var fetchUsersState = FetchUsersState.none
}
