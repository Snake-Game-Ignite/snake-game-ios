//
//  Point.swift
//  snakegame
//
//  Created by Vlad Z on 21/01/2024.
//

import Foundation

struct Point: Codable, Equatable {
    var x: Double
    var y: Double

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
