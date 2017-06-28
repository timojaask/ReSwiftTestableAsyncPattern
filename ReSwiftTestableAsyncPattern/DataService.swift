import PromiseKit

protocol DataService {
    func fetchData() -> Promise<String>
}
