//
//  Point.swift
//  snakegame
//
//  Created by David Southgate on 22/01/2024.
//

import Foundation
import UIKit

struct Point: Equatable {
    let x: Int
    let y: Int
    
    func direction(of point: Point) -> Direction {
        if point.x < self.x {
            return .left
        } else if point.x > self.x {
            return .right
        } else if point.y < self.y {
            return .up
        } else {
            return .down
        }
    }
}
