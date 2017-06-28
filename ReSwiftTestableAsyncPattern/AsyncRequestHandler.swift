import ReSwift
import PromiseKit

class AsyncRequestHandler: StoreSubscriber {
    let dataService: DataService
    let store: DispatchingStoreType

    init(dataService: DataService, store: DispatchingStoreType) {
        self.dataService = dataService
        self.store = store
    }

    func newState(state: AppState) {
        if case FetchDataState.request = state.fetchDataState {
            dataService.fetchData()
                .then { self.store.dispatch(SetFetchDataState(.success(data: $0))) }
                .catch { self.store.dispatch(SetFetchDataState(.error(error: $0))) }
        }
    }
}
