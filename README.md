# ReSwift Testable Async Pattern
An example of writing testable code with asynchronous requests using ReSwift, leaving your actions and reducers free of side-effects.

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

This makes it difficult to test action creates, as it is not clear how to replace `Octokit` object with a test stub.

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
