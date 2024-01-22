//
//  CellNode.swift
//  snakegame
//
//  Created by David Southgate on 22/01/2024.
//

import SpriteKit

class CellNode: SKSpriteNode {
    let cell: Cell
    
    init(cell: Cell, cellSize: CGFloat) {
        self.cell = cell
        let size = CGSize(width: cellSize, height: cellSize)
        super.init(texture: nil, color: .clear, size: size)
        addChild(imageNode)
        if let overlayNode {
            addChild(overlayNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageNode: SKSpriteNode = {
        guard let imageName = cell.imageName else {
            return SKSpriteNode(imageNamed: "")
        }
        let node = SKSpriteNode(imageNamed: imageName)
        if let color = cell.color {
            node.color = color
            node.colorBlendFactor = 1
        }
        node.size = size
        return node
    }()
    
    lazy var overlayNode: SKSpriteNode? = {
        guard let imageName = cell.overlayImageName else {
            return nil
        }
        let node = SKSpriteNode(imageNamed: imageName)
        node.size = size
        return node
    }()
}
