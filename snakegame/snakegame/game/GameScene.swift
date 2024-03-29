//
//  GameScene.swift
//  snakegame
//
//  Created by Vlad Z on 21/01/2024.
//

import SpriteKit

class GameScene: SKScene {
    static let rows = 50
    static let cols = 50
    
    var viewModel: GameViewModel!
    let grid = GridNode(rows: GameScene.rows, cols: GameScene.cols, cellSize: 10)
    
    override func didMove(to: SKView) {
        addChild(grid)
    }
    
    // A bit inefficient
    override func update(_ currentTime: TimeInterval) {
        guard viewModel.state != viewModel.prevState else {
            return
        }
        grid.removeAllChildren()
        for item in viewModel.cells {
            grid.addCell(item.cell, at: item.point)
        }
        viewModel.prevState = viewModel.state
    }
    
    func move(direction: Direction) {
        viewModel.move(direction: direction)
    }
}
