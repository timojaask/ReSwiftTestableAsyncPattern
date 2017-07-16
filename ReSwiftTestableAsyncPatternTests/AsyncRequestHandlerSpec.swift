import Quick
import Nimble
import PromiseKit
import ReSwift

class AsyncRequestHandlerSpec: QuickSpec {

    override func spec() {
        describe("") {

            it("dispatches success action with correct data after successful request") {
                let testUsers = [User(firstName: "First 1", lastName: "Last 1"),
                                 User(firstName: "First 2", lastName: "Last 2")]
                let testStore = TestStore()
                requestData(store: testStore, testUsers: testUsers)

                let expectedAction = SetFetchUsers(state: .success(users: testUsers))
                expect(testStore.dispatchedAction).toEventually(equal(expectedAction), timeout: 1)
            }

            it("dispatches error action with correct error after failed request") {
                let testError = TestError.someError
                let testStore = TestStore()
                requestData(store: testStore, testUsers: [], failing: true, error: testError)

                let expectedAction = SetFetchUsers(state: .error(error: testError))
                expect(testStore.dispatchedAction).toEventually(equal(expectedAction), timeout: 1)
            }
        }
    }
}


struct TestDataService: DataService {
    let users: [User]
    let failing: Bool
    let error: Error

    func fetchUsers() -> Promise<[User]> {
        if failing {
            return Promise.init(error: error)
        }
        return Promise.init(value: users)
    }

    func fetchPosts() -> Promise<[Post]> {
        fatalError("Not implemented")
    }

    func createPost(post: Post) -> Promise<Void> {
        fatalError("Not implemented")
    }
}

class TestStore: DispatchingStoreType {
    var dispatchedAction = SetFetchUsers(state: .none)
    func dispatch(_ action: Action) {
        dispatchedAction = action as! SetFetchUsers
    }
}

enum TestError: Error {
    case someError
}


func requestData(store: DispatchingStoreType, testUsers: [User], failing: Bool = false, error: Error = TestError.someError) {
    let testDataService = TestDataService(users: testUsers, failing: failing, error: error)
    let asyncRequestHandler = AsyncRequestHandler(dataService: testDataService, store: store)

    let newState = AppState(
        users: [],
        posts: [],
        fetchUsers: FetchUsers.request,
        fetchPosts: FetchPosts.none,
        createPost: CreatePost.none
    )
    asyncRequestHandler.newState(state: newState)
}
