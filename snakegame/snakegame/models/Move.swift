//
//  Move.swift
//  snakegame
//
//  Created by Vlad Z on 21/01/2024.
//

import Foundation
/*
 {
    "playerId" : 1,
    "moveDirection" : 1
 }
 */
struct Move: Codable {
    
    var playerId: String
    var direction: Int
    
    init(playerId: String, move: Direction) {
        self.playerId = playerId
        direction = move.rawValue
    }
}
