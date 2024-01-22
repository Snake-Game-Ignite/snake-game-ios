//
//  GameViewModel.swift
//  snakegame
//
//  Created by David Southgate on 22/01/2024.
//

import UIKit

class GameViewModel {
    typealias CellWithPoint = (cell: Cell, point: Point)
    let rows: Int
    let cols: Int
    let colors: [UIColor] = [.systemOrange, .systemBlue]
    var prevState: GameState?
    var state: GameState?
    
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        NetworkManager.shared.getState { [weak self] state in
            self?.state = state
        }
    }
    
    var cells: [CellWithPoint] {
        return fruitCells + snakeCells
    }
    
    private var fruitCells: [CellWithPoint] {
        guard let state else {
            return []
        }
        return state.fruit.map { point in
            return (cell: .fruit, point: point)
        }
    }
    
    private var snakeCells: [CellWithPoint] {
        guard let state else {
            return []
        }
        return (0..<state.snakes.count).flatMap { snakeIndex in
            let snake = state.snakes[snakeIndex].snake
            let color = colors[snakeIndex % colors.count]
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
    
    func move(direction: Direction) {
        NetworkManager.shared.makeMove(move: Move(playerId: 1, move: direction)) { [weak self] in
            NetworkManager.shared.getState { [weak self] state in
                self?.state = state
            }
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
