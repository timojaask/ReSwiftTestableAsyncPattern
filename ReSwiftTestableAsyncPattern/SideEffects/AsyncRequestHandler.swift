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
            print("AsyncRequestHandler: fetchUsers")
            store.dispatch(SetFetchUsers(state: .loading))
            dataService.fetchUsers()
                .then { self.store.dispatch(SetFetchUsers(state: .success(users: $0))) }
                .catch { self.store.dispatch(SetFetchUsers(state: .error(error: $0))) }
        }

        if case FetchPosts.request = state.fetchPosts {
            print("AsyncRequestHandler: fetchPosts")
            store.dispatch(SetFetchPosts(state: .loading))
            dataService.fetchPosts()
                .then { self.store.dispatch(SetFetchPosts(state: .success(posts: $0))) }
                .catch { self.store.dispatch(SetFetchUsers(state: .error(error: $0))) }
        }

        if case CreatePost.request(let post) = state.createPost {
            print("AsyncRequestHandler: createPost")
            store.dispatch(SetCreatePost(state: .loading))
            dataService.createPost(post: post)
                .then { self.store.dispatch(SetCreatePost(state: .success())) }
                .catch { self.store.dispatch(SetCreatePost(state: .error(error: $0))) }
        }
    }
}
