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
    
    var playerId: Int
    var moveDirection: Int
    
    init(playerId: Int, move: Direction) {
        self.playerId = playerId
        moveDirection = move.rawValue
    }
}
