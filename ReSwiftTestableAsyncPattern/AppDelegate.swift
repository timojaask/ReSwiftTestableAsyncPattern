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
        asyncRequestHandler = AsyncRequestHandler(dataService: AppDataService(), store: store)
        store.subscribe(debugStoreSubscriber)
        store.dispatch(SetFetchDataState(.request))
        return true
    }
}

struct AppDataService: DataService {
    func fetchData() -> Promise<String> {
        return Promise<String> { fulfill, reject in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                fulfill("Hello from app data service")
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
