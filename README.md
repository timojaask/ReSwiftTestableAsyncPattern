# ReSwift Testable Async Pattern
An example of writing testable code with asynchronous requests using ReSwift, leaving your actions and reducers free of side-effects. See the example project for fully functional code with unit tests.

## Problem
ReSwift documentation suggests to fire asynchronous operations directcly from within action creators:

```swift
func fetchGitHubRepositories(state: State, store: Store<State>) -> Action? {
    guard case let .LoggedIn(configuration) = state.authenticationState.loggedInState  else { return nil }

    Octokit(configuration).repositories { response in
        dispatch_async(dispatch_get_main_queue()) {
            store.dispatch(SetRepostories(repositories: .Repositories(response)))
        }
    }

    return SetRepositories(repositories: .Loading)
}
```

This makes it difficult to test action creators, as it is not clear how to replace `Octokit` object with a test stub.

## Solution
Instead of firing asynchronous operations from withing action creators, fire them from a separate dedicated class, which can be unit tested:

```swift
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
```

Whenever `state.fetchDataState` value is set to `FetchDataState.request`, `AsyncRequestHandler` will initiate the `fetchData` asynchronous operation.

## Testing
`AsyncRequestHandler` can be tested by giving it fake store and data service:
```swift
let testStore = TestStore()
let testDataService = TestDataService(data: "Hello")
let asyncRequestHandler = AsyncRequestHandler(dataService: testDataService, store: testStore)

let newState = AppState(remoteData: "", fetchDataState: FetchDataState.request)
asyncRequestHandler.newState(state: newState)

let expectedAction = SetFetchDataState(.success(data: "Hello"))
expect(testStore.dispatchedAction).toEventually(equal(expectedAction), timeout: 1)
```

## Drawbacks and future improvements
With the current implementation, you'd have to create a new enum for each new asynchronous action:

```swift
enum FetchPostsState {
    case none
    case request
    case success(posts: [Post])
    case error(error: Error)
}
enum FetchUsersState {
    case none
    case request
    case success(users: [User])
    case error(error: Error)
}
enum FetchWhateverState {
    case none
    case request
    case success(whatever: Whatever)
    case error(error: Error)
}

struct FetchPosts: Action { let state: FetchPostsState }
struct FetchUsers: Action { let state: FetchUsersState }
struct FetchWhatever: Action { let state: FetchWhateverState }
```

This will eventually be possible to solve using generics when [SE-0143](https://github.com/apple/swift-evolution/blob/master/proposals/0143-conditional-conformances.md) gets released at some point with [Swift 4.x](https://twitter.com/jckarter/status/872211469856722944). Then you would be able to create a generic asynchronous request state enum, which would be used with every asynchronous action:

```swift
enum AsyncRequestState<T> {
    case none
    case request
    case success(result: T)
    case error(error: Error)
}

struct FetchPosts: Action { let state: AsyncRequestState<[Post]> }
struct FetchUsers: Action { let state: AsyncRequestState<[User]> }
struct FetchWhatever: Action { let state: AsyncRequestState<Whatever> }
```
