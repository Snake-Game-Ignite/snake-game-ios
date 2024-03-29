//
//  WebsocketManager.swift
//  snakegame
//
//  Created by David Southgate on 29/01/2024.
//

import Combine
import Foundation

class WebSocketManager {
    static let shared = WebSocketManager()
    var state = PassthroughSubject<GameState, Never>()
    
    private var webSocketTask: URLSessionWebSocketTask?

    init() {
        self.connect()
    }
    
    public func makeMove(_ move: Move) {
        do {
            let data = try JSONEncoder().encode(move)
            let string = String(decoding: data, as: UTF8.self)
            webSocketTask?.send(.string(string)) { _ in
                print("Made move")
            }
        } catch {
            print(error)
        }
    }
    
    private func connect() {
        guard let url = URL(string: "ws://127.0.0.1/ws") else { return }
        var request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
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
        } catch {
            print(error)
        }
    }
}
