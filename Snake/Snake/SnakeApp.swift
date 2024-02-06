//
//  SnakeApp.swift
//  Snake
//
//  Created by Vlad Z on 06/02/2024.
//

import SwiftUI

@main
struct SnakeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(gameState: GameState(
                gameOver: false,
                message: "",
                snakes: ["Player1": [Point(x: 5, y: 5), Point(x: 5, y: 6), Point(x: 5, y: 7)],
                         "Player2": [Point(x: 10, y: 10), Point(x: 10, y: 11), Point(x: 10, y: 12)]],
                fruits: [Point(x: 3, y: 3), Point(x: 15, y: 20)],
                score: ["Player1": 50, "Player2": 30]
            ))
        }
    }
}
