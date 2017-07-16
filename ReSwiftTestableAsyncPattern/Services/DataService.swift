import PromiseKit

protocol DataService {
    func fetchUsers() -> Promise<[User]>
    func fetchPosts() -> Promise<[Post]>
}
