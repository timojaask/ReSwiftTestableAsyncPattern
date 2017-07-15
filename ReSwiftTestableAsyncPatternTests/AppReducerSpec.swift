import Quick
import Nimble

class AppReducerSpec: QuickSpec {

    override func spec() {
        describe("SetFetchDataState") {

            it("changes fetchDataState to request when action state is request") {
                let stateBefore = initialAppState()
                let stateAfter = appReducer(action: SetFetchUsersState(state: .request), state: stateBefore)

                expect(stateBefore.fetchUsersState).to(equal(FetchUsersState.none))
                expect(stateAfter.fetchUsersState).to(equal(FetchUsersState.request))
            }

            it("changes fetchDataState to success with correct payload when action state is success") {
                let testUsers = [User(firstName: "First 1", lastName: "Last 1"),
                                 User(firstName: "First 2", lastName: "Last 2")]

                let stateBefore = initialAppState()
                let stateAfter = appReducer(action: SetFetchUsersState(state: .success(users: testUsers)), state: stateBefore)

                expect(stateAfter.fetchUsersState).to(equal(FetchUsersState.success(users: testUsers)))
            }

            it("changes fetchDataState to error with correct payload when action state is error") {
                enum TestError: Error { case someError }
                let testError = TestError.someError

                let stateBefore = initialAppState()
                let stateAfter = appReducer(action: SetFetchUsersState(state: .error(error: testError)), state: stateBefore)

                expect(stateAfter.fetchUsersState).to(equal(FetchUsersState.error(error: testError)))
            }
        }
    }
}
