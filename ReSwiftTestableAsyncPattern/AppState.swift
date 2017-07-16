import ReSwift

struct AppState: StateType {
    var users: [User] = []
    var fetchUsers = FetchUsers.none
}
