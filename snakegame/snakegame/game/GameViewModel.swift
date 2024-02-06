//
//  GameViewModel.swift
//  snakegame
//
//  Created by David Southgate on 22/01/2024.
//

import Combine
import UIKit

@Observable
class GameViewModel {
    typealias CellWithPoint = (cell: Cell, point: Point)
    let rows: Int
    let cols: Int
    let colors: [UIColor] = [.systemOrange, .systemBlue, .systemGreen, .systemPink]
    var playerColors: [String: UIColor] = [:]
    var prevState: GameState?
    var state: GameState?
    var bag: Set<AnyCancellable> = Set()
    var player = 1
    
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        WebSocketManager.shared.state
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &bag)
    }
    
    var cells: [CellWithPoint] {
        return fruitCells + snakeCells
    }
    
    private var fruitCells: [CellWithPoint] {
        guard let state else {
            return []
        }
        return state.fruits.map { point in
            return (cell: .fruit, point: point)
        }
    }
    
    private var snakeCells: [CellWithPoint] {
        guard let state else {
            return []
        }
        var snakeIndex = 0
        return state.snakes.flatMap { playerId, snake in
            let color: UIColor
            if let playerColor = playerColors[playerId]  {
                color = playerColor
            } else {
                color = colors[playerColors.count % colors.count]
                playerColors[playerId] = color
            }
            snakeIndex += 1
            return (0..<snake.count).map { i in
                let prevPosition = snake[at: i - 1]
                let currentPosition = snake[i]
                let nextPosition = snake[at: i + 1]
                return (
                    cell: snakeCell(color: color, prev: prevPosition, current: currentPosition, next: nextPosition),
                    point: currentPosition
                )
            }
        }
    }
    
    var color: UIColor {
        return playerColors[playerId] ?? .clear
    }
    
    func move(direction: Direction) {
        let move = Move(playerId: playerId, move: direction)
        WebSocketManager.shared.makeMove(move)
    }
    
    func reset() {
        NetworkManager.shared.reset()
    }
    
    var playerId: String {
        switch player {
        case 1:
            return "ios"
        case 2:
            return "android"
        default:
            return "player1"
        }
    }
}

extension GameViewModel {
    
    private func snakeCell(color: UIColor, prev: Point?, current: Point, next: Point?) -> Cell {
        if prev == nil,
           let next {
            let direction = next.direction(of: current)
            return .head(color: color, direction: direction)
        }
        if next == nil,
           let prev {
            let direction = prev.direction(of: current)
            return .tail(color: color, direction: direction)
        }
        if let prev,
           let next {
            return bodyCell(color: color, prev: prev, current: current, next: next)
        }
        return .empty
    }
    
    private func bodyCell(color: UIColor, prev: Point, current: Point, next: Point) -> Cell {
        let prevDirection = current.direction(of: prev)
        let nextDirection = current.direction(of: next)
        let directions = [prevDirection, nextDirection].sorted()
        switch directions {
        case [.right, .left]:
            return .body(color: color, direction: .horizontal)
        case [.up, .down]:
            return .body(color: color, direction: .vertical)
        case [.up, .right]:
            return .body(color: color, direction: .topRight)
        case [.right, .down]:
            return .body(color: color, direction: .bottomRight)
        case [.down, .left]:
            return .body(color: color, direction: .bottomLeft)
        case [.up, .left]:
            return .body(color: color, direction: .topLeft)
        default:
            return .empty
        }
    }
}
