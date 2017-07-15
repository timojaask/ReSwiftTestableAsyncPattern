import ReSwift

enum FetchDataState {
    case none
    case request
    case success(data: String)
    case error(error: Error)
}

struct SetFetchDataState: Action {
    let state: FetchDataState
}
