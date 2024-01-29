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
        guard let url = URL(string: host + "api/snake/state") else {
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
                    print(error)
                    completion(nil)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func makeMove(move: Move, completion: @escaping (() -> Void)) {
        guard let url = URL(string: host + "api/snake/move") else {
            return
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        
        
        let jsonData = try! encoder.encode(move)
        
        postRequest(url: url, body: jsonData) { result in
            completion()
        }
    }
    
    public func reset() {
        guard let url = URL(string: host + "api/snake/reset") else {
            return
        }
        let request = ResetRequest(boardSize: 50, keepScore: true, initialSnakeLength: nil)
        let jsonData = try! JSONEncoder().encode(request)
        postRequest(url: url, body: jsonData) { result in
        }
    }
}

struct ResetRequest: Codable {
    let boardSize: Int?
    let keepScore: Bool?
    let initialSnakeLength: Int?
}
                   
