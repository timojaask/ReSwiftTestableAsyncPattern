import PromiseKit

protocol DataService {
    func fetchUsers() -> Promise<[User]>
}
