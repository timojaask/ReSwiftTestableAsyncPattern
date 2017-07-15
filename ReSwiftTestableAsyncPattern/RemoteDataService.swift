import PromiseKit

struct RemoteDataService: DataService {
    func fetchData() -> Promise<String> {
        return Promise<String> { fulfill, reject in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                fulfill("Hello from app data service")
            }
        }
    }
}
