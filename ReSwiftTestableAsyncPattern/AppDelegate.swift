import UIKit
import ReSwift
import PromiseKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let store = Store<AppState>(reducer: appReducer, state: nil)
    var asyncRequestHandler: AsyncRequestHandler?

    let debugStoreSubscriber = DebugStoreSubscriber()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        asyncRequestHandler = AsyncRequestHandler(dataService: TestDataService(), store: store)
        store.subscribe(debugStoreSubscriber)
        store.dispatch(SetFetchDataState(.request))
        return true
    }
}

enum FetchDataState {
    case none
    case request
    case success(data: String)
    case error(error: Error)
}

struct SetFetchDataState: Action {
    let state: FetchDataState
    init(_ state: FetchDataState) { self.state = state }
}

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

struct AppState: StateType {
    var remoteData = ""
    var fetchDataState = FetchDataState.none
}

class AsyncRequestHandler: StoreSubscriber {
    let dataService: DataService
    let store: Store<AppState>

    init(dataService: DataService, store: Store<AppState>) {
        self.dataService = dataService
        self.store = store
        store.subscribe(self)
    }

    func newState(state: AppState) {
        if case FetchDataState.request = state.fetchDataState {
            dataService.fetchData()
                .then { self.store.dispatch(SetFetchDataState(.success(data: $0))) }
                .catch { self.store.dispatch(SetFetchDataState(.error(error: $0))) }
        }
    }
}

protocol DataService {
    func fetchData() -> Promise<String>
}

struct TestDataService: DataService {
    func fetchData() -> Promise<String> {
        return Promise<String> { fulfill, reject in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                fulfill("Hello from test data service")
            }
        }
    }
}

class DebugStoreSubscriber: StoreSubscriber {
    func newState(state: AppState) {
        print("State changed")
        print(" -- fetch state: \(state.fetchDataState)")
        print(" -- data: \(state.remoteData)")
    }
}
