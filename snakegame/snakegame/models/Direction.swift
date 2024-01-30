//
//  Direction.swift
//  snakegame
//
//  Created by Vlad Z on 21/01/2024.
//  Created by David Southgate on 22/01/2024.
//

import Foundation

enum Direction: Int, Comparable {
    case up = 3
    case right = 2
    case down = 1
    case left = 0

    static func < (lhs: Direction, rhs: Direction) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
}
