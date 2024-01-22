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
    var state: GameState = .initial
    
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
    }
    
    var cells: [CellWithPoint] {
        return fruitCells + snakeCells
    }
    
    private var fruitCells: [CellWithPoint] {
        return state.fruit.map { point in
            return (cell: .fruit, point: point)
        }
    }
    
    private var snakeCells: [CellWithPoint] {
        (0..<state.snakes.count).flatMap { snakeIndex in
            let snake = state.snakes[snakeIndex]
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
    
    // TEMPORARY
    func move(direction: Direction) {
        let otherSnakes = state.snakes.suffix(state.snakes.count - 1)
        guard var mySnake = state.snakes.first,
              let first = mySnake.first else {
            return
        }
        var fruit = state.fruit
        let next: Point
        switch direction {
        case .up:
            next = Point(x: first.x, y: first.y - 1)
        case .left:
            next = Point(x: first.x - 1, y: first.y)
        case .right:
            next = Point(x: first.x + 1, y: first.y)
        case .down:
            next = Point(x: first.x, y: first.y + 1)
        }
        
        let eatingFruit = fruit.contains(next)
        
        if eatingFruit {
            mySnake = [next] + mySnake
        } else {
            mySnake = [next] + mySnake.prefix(mySnake.count - 1)
        }
        let snakes = [mySnake] + otherSnakes
        
        if eatingFruit {
            fruit.removeAll { $0 == next}
            fruit.append(randomFruit(snakes: snakes, fruit: fruit))
        }

        state = GameState(fruit: fruit,
                           snakes: [mySnake] + otherSnakes)
    }
    
    // TEMPORARY - Will crash/hang once game is full :)
    func randomFruit(snakes: [[Point]], fruit: [Point]) -> Point {
        while true {
            let point = Point(x: Int.random(in: 0..<cols),
                                  y: Int.random(in: 0..<rows))
            if  fruit.contains(point) {
                continue
            }
            for snake in snakes {
                if snake.contains(point) {
                    continue
                }
            }
            return point
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
