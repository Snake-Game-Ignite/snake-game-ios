//
//  WebSocketManager.swift
//  Snake
//
//  Created by Vlad Z on 06/02/2024.
//

import Combine
import Foundation

class WebSocketManager: ObservableObject {
    static let shared = WebSocketManager()
    var state = PassthroughSubject<GameState, Never>()
    
    @Published var gameState = GameState(
        gameOver: false,
        message: "",
        snakes: [:],
        fruits: [],
        score: [:]
    )
    
    private var webSocketTask: URLSessionWebSocketTask?

    init() {
        self.connect()
    }
    
    // "ws://localhost:8080/ws"http://35.178.166.250:8080/
    private func connect() {
        guard let url = URL(string: "ws://13.41.203.145:8080/ws") else { return }
        var request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocketTask?.receive() { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                 fatalError()
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleString(string: text)
                case .data:
                    print("Error: Unable to handle data")
                    break
                @unknown default:
                    break
                }
                self?.receiveMessage()
            }
        }
    }
    
    private func handleString(string: String) {
        do {
            let data = Data(string.utf8)
            let newState = try JSONDecoder().decode(GameState.self, from: data)
            state.send(newState)
            print(newState)
            DispatchQueue.main.async {
                self.gameState = newState
            }
            
        } catch {
            print(error)
        }
    }
}

