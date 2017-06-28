import ReSwift

struct AppState: StateType {
    var remoteData = ""
    var fetchDataState = FetchDataState.none
}
