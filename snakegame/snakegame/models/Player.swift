//
//  Player.swift
//  snakegame
//
//  Created by Vlad Z on 21/01/2024.
//

import Foundation

/*
 {
    "id":1,
    "score":0,
    "snake":[{"x":1.0,"y":5.0},{"x":1.0,"y":6.0},{"x":1.0,"y":7.0},{"x":1.0,"y":8.0}]}
 */
struct Player: Codable {
    
    var id: Int
    var score: Int
    var snake: [Point]
    
}
