import Foundation

class NetworkManager {
    
    let host = "http://localhost:8080/"
    static let shared = NetworkManager()
    
    // MARK: - Public Methods
    
    private func execute(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let success = (200...299)
            guard let httpResponse = response as? HTTPURLResponse, success.contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let errorMessage = "Unexpected response: \(statusCode)"
                completion(.failure(NSError(domain: "NetworkError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                let errorMessage = "No data received"
                completion(.failure(NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }
        
        task.resume()
    }
    
    func getRequest(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        execute(request: request, completion: completion)
        
    }
    
    func postRequest(url: URL, body: Data?, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        execute(request: request, completion: completion)
    }
    
    func getState(completion: @escaping ((GameState?) -> Void)) {
        guard let url = URL(string: host + "state") else {
            completion(nil)
            return
        }
        
        getRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let state = try JSONDecoder().decode(GameState.self, from: data)
                    completion(state)
                } catch {
                    completion(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func makeMove(move: Move) {
        guard let url = URL(string: host + "move") else {
            return
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        
        
        let jsonData = try! encoder.encode(move)
        
        postRequest(url: url, body: jsonData) { result in
            print(result)
        }
    }
}
                   
