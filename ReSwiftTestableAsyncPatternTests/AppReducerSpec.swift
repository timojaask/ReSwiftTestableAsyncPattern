import Quick
import Nimble

class AppReducerSpec: QuickSpec {

    override func spec() {
        describe("SetFetchDataState") {

            it("changes fetchDataState to request when action state is request") {
                let stateBefore = initialAppState()
                let stateAfter = appReducer(action: SetFetchDataState(state: .request), state: stateBefore)

                expect(stateBefore.fetchDataState).to(equal(FetchDataState.none))
                expect(stateAfter.fetchDataState).to(equal(FetchDataState.request))
            }

            it("changes fetchDataState to success with correct payload when action state is success") {
                let testData = "Some test data"

                let stateBefore = initialAppState()
                let stateAfter = appReducer(action: SetFetchDataState(state: .success(data: testData)), state: stateBefore)

                expect(stateAfter.fetchDataState).to(equal(FetchDataState.success(data: testData)))
            }

            it("changes fetchDataState to error with correct payload when action state is error") {
                enum TestError: Error { case someError }
                let testError = TestError.someError

                let stateBefore = initialAppState()
                let stateAfter = appReducer(action: SetFetchDataState(state: .error(error: testError)), state: stateBefore)

                expect(stateAfter.fetchDataState).to(equal(FetchDataState.error(error: testError)))
            }
        }
    }
}
