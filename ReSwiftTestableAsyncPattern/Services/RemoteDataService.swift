import PromiseKit

struct RemoteDataService: DataService {
    func fetchUsers() -> Promise<[User]> {
        return Promise<[User]> { fulfill, reject in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                fulfill([User(firstName: "", lastName: "")])
            }
        }
    }
}
