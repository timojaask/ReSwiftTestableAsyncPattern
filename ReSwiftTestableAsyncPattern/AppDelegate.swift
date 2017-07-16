import UIKit
import ReSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let store = Store<AppState>(reducer: appReducer, state: nil)
    var asyncRequestHandler: AsyncRequestHandler?

    let debugStoreSubscriber = DebugStoreSubscriber()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        asyncRequestHandler = AsyncRequestHandler(dataService: RemoteDataService(), store: store)
        store.subscribe(asyncRequestHandler!)
        store.subscribe(debugStoreSubscriber)
        store.dispatch(SetFetchUsers(state: .request))
        store.dispatch(SetFetchPosts(state: .request))
        store.dispatch(SetCreatePost(state: .request(post: Post(title: "Another post", body: "Hello post"))))
        store.dispatch(SetFetchPosts(state: .request))
        return true
    }
}

class DebugStoreSubscriber: StoreSubscriber {
    func newState(state: AppState) {
        print("")
        print("State changed")
        print(" -- users: \(state.users)")
        print(" -- posts: \(state.posts)")
        print(" -- fetchUsers: \(state.fetchUsers)")
        print(" -- fetchPosts: \(state.fetchPosts)")
        print(" -- createPost: \(state.createPost)")
    }
}
