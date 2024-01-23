//
//  Grid.swift
//  snakegame
//
//  Created by David Southgate on 22/01/2024.
//

import SpriteKit

class GridNode: SKSpriteNode {
    let rows: Int
    let cols: Int
    let cellSize: CGFloat
    
    /// The X position of the cell at grid location (0,0)
    lazy var originX: CGFloat = {
        -(cellSize * CGFloat(cols) / 2) + cellSize/2
    }()
    
    /// The Y position of the cell at grid location (0,0)
    lazy var originY: CGFloat = {
        (cellSize * CGFloat(rows) / 2) - cellSize/2
    }()
    
    init(rows: Int, cols: Int, cellSize: CGFloat) {
        self.rows = rows
        self.cols = cols
        self.cellSize = cellSize
        let width = CGFloat(cols) * cellSize
        let height = CGFloat(rows) * cellSize
        let size = CGSize(width: width, height: height)
        super.init(texture: Self.texture(size: size), color: .clear, size: size)
    }
    
    static func texture(size: CGSize) -> SKTexture? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            ctx.cgContext.setStrokeColor(UIColor.white.cgColor)
            ctx.cgContext.setLineWidth(1)
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .stroke)
        }
        return SKTexture(image: image)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCell(_ cell: Cell, at point: Point) {
        let position = self.gridPosition(x: point.x, y: point.y)
        let node = CellNode(cell: cell, cellSize: cellSize)
        node.position = position
        addChild(node)
    }
    
    private func gridPosition(x: Int, y: Int) -> CGPoint {
        let pointX = originX + cellSize * CGFloat(x)
        let pointY = originY - cellSize * CGFloat(y)
        return CGPoint(x: pointX, y: pointY)
    }
}
