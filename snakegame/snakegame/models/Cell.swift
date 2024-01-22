//
//  Cell.swift
//  snakegame
//
//  Created by David Southgate on 22/01/2024.
//

import UIKit

enum Cell {
    case body(color: UIColor, direction: CellBodyDirection)
    case head(color: UIColor, direction: Direction)
    case tail(color: UIColor, direction: Direction)
    case fruit
    case empty
}

extension Cell {
    
    var color: UIColor? {
        switch self {
        case .body(let color, _):
            return color
        case .head(let color, _):
            return color
        case .tail(let color, _):
            return color
        default:
            return nil
        }
    }
    
    var imageName: String? {
        switch self {
        case .body(_, let direction):
            switch direction {
            case .bottomLeft:
                return "BodyBottomLeft"
            case .bottomRight:
                return "BodyBottomRight"
            case .horizontal:
                return "BodyHorizontal"
            case .topLeft:
                return "BodyTopLeft"
            case .topRight:
                return "BodyTopRight"
            case .vertical:
                return "BodyVertical"
            }
        case .head(_, let direction):
            switch direction {
            case .down:
                return "HeadDown"
            case .left:
                return "HeadLeft"
            case .right:
                return "HeadRight"
            case .up:
                return "HeadUp"
            }
        case .tail(_, let direction):
            switch direction {
            case .down:
                return "TailDown"
            case .left:
                return "TailLeft"
            case .right:
                return "TailRight"
            case .up:
                return "TailUp"
            }
        case .fruit:
            return "Fruit"
        case .empty:
            return nil
        }
    }
    
    var overlayImageName: String? {
        switch self {
        case .head(_, let direction):
            switch direction {
            case .down:
                return "HeadDown-Eyes"
            case .left:
                return "HeadLeft-Eyes"
            case .right:
                return "HeadRight-Eyes"
            case .up:
                return "HeadUp-Eyes"
            }
        default:
            return nil
        }
    }
}
