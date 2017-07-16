import Quick
import Nimble

class AppReducerSpec: QuickSpec {

    override func spec() {
        describe("SetFetchDataState") {

            it("changes fetchDataState to request when action state is request") {
                let stateBefore = initialAppState()
                let stateAfter = appReducer(action: SetFetchUsers(state: .request), state: stateBefore)

                expect(stateBefore.fetchUsers).to(equal(FetchUsers.none))
                expect(stateAfter.fetchUsers).to(equal(FetchUsers.request))
            }

            it("changes fetchDataState to success with correct payload when action state is success") {
                let testUsers = [User(firstName: "First 1", lastName: "Last 1"),
                                 User(firstName: "First 2", lastName: "Last 2")]

                let stateBefore = initialAppState()
                let stateAfter = appReducer(action: SetFetchUsers(state: .success(users: testUsers)), state: stateBefore)

                expect(stateAfter.fetchUsers).to(equal(FetchUsers.success(users: testUsers)))
            }

            it("changes fetchDataState to error with correct payload when action state is error") {
                enum TestError: Error { case someError }
                let testError = TestError.someError

                let stateBefore = initialAppState()
                let stateAfter = appReducer(action: SetFetchUsers(state: .error(error: testError)), state: stateBefore)

                expect(stateAfter.fetchUsers).to(equal(FetchUsers.error(error: testError)))
            }
        }
    }
}
