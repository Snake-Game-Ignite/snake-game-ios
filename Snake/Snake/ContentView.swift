//
//  ContentView.swift
//  Snake
//
//  Created by Vlad Z on 06/02/2024.
//

import SwiftUI

struct ContentView: View {
    let gameState: GameState
    @ObservedObject var webSocketManager = WebSocketManager.shared
    
    var body: some View {
            VStack {
                // Display scores at the top
                HStack {
                    ForEach(
                        webSocketManager.gameState.score.sorted(by: { $0.value > $1.value }), id: \.key) { playerName, score in
                        Text("\(playerName): \(score)")
                    }
                }
                
                // Display the game board
                GridView(gameState: webSocketManager.gameState)
            }
        }
}

struct GridView: View {
    let gameState: GameState
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<20, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<20, id: \.self) { column in
                        let point = Point(x: column, y: row)
                        if let snakeColor = snakeColor(for: point) {
                            Rectangle()
                                .fill(snakeColor)
                                .frame(width: 40, height: 40)
                        } else if isFruit(at: point) {
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 40, height: 40)
                        } else {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
        }
    }
    
    func snakeColor(for point: Point) -> Color? {
            for (_, snakePoints) in gameState.snakes {
                if snakePoints.contains(point) {
                    return Color.blue // or Color.green
                }
            }
            return nil
        }
        
        func isFruit(at point: Point) -> Bool {
            return gameState.fruits.contains(point)
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            let gameState = GameState(gameOver: false,
                                      message: "",snakes: [:], fruits: [], score: ["Player 1": 10, "Player 2": 20])
            ContentView(gameState: gameState)
        }
    }

#Preview {
    let gameState = GameState(
        gameOver: false,
        message: "",
        snakes: ["Player1": [Point(x: 5, y: 5), Point(x: 5, y: 6), Point(x: 5, y: 7)],
                 "Player2": [Point(x: 20, y: 10), Point(x: 10, y: 11), Point(x: 10, y: 12)]],
        fruits: [Point(x: 3, y: 3), Point(x: 15, y: 20)],
        score: ["Player1": 50, "Player2": 30]
    )
    return ContentView(gameState: gameState)
}
