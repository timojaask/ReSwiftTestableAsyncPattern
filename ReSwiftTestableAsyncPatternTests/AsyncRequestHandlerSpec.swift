import Quick
import Nimble
import PromiseKit
import ReSwift

class AsyncRequestHandlerSpec: QuickSpec {

    override func spec() {
        describe("") {

            it("dispatches success action with correct data after successful request") {
                let testData = "Some test data"
                let testStore = TestStore()
                requestData(store: testStore, testData: testData)

                let expectedAction = SetFetchDataState(state: .success(data: testData))
                expect(testStore.dispatchedAction).toEventually(equal(expectedAction), timeout: 1)
            }

            it("dispatches error action with correct error after failed request") {
                let testError = TestError.someError
                let testStore = TestStore()
                requestData(store: testStore, testData: "", failing: true, error: testError)

                let expectedAction = SetFetchDataState(state: .error(error: testError))
                expect(testStore.dispatchedAction).toEventually(equal(expectedAction), timeout: 1)
            }
        }
    }
}


struct TestDataService: DataService {
    let data: String
    let failing: Bool
    let error: Error

    func fetchData() -> Promise<String> {
        if failing {
            return Promise.init(error: error)
        }
        return Promise.init(value: data)
    }
}

class TestStore: DispatchingStoreType {
    var dispatchedAction = SetFetchDataState(state: .none)
    func dispatch(_ action: Action) {
        dispatchedAction = action as! SetFetchDataState
    }
}

enum TestError: Error {
    case someError
}


func requestData(store: DispatchingStoreType, testData: String, failing: Bool = false, error: Error = TestError.someError) {
    let testDataService = TestDataService(data: testData, failing: failing, error: error)
    let asyncRequestHandler = AsyncRequestHandler(dataService: testDataService, store: store)

    let newState = AppState(remoteData: "", fetchDataState: FetchDataState.request)
    asyncRequestHandler.newState(state: newState)
}
