//
//  Direction.swift
//  snakegame
//
//  Created by David Southgate on 22/01/2024.
//

import Foundation

enum Direction: Int, Comparable {
    case up = 0
    case right = 1
    case down = 2
    case left = 3
    
    static func < (lhs: Direction, rhs: Direction) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
