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
        if case FetchUsers.request = state.fetchUsers {
            dataService.fetchUsers()
                .then { self.store.dispatch(SetFetchUsers(state: .success(users: $0))) }
                .catch { self.store.dispatch(SetFetchUsers(state: .error(error: $0))) }
        }
    }
}
