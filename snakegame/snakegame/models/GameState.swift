//
//  GameState.swift
//  snakegame
//
//  Created by Vlad Z on 21/01/2024.
//

import Foundation

/*
 {
   "gameOver": false,
   "message": "",
   "snakes": {
     "player1": [
       {"x": 1, "y": 3},
       {"x": 1, "y": 4},
       {"x": 1, "y": 5}
     ],
     "player2": [
       {"x": 4, "y": 0},
       {"x": 4, "y": 1},
       {"x": 4, "y": 2}
     ]
   },
   "fruits": [
     {"x": 3, "y": 2}
   ],
   "board": [
     [0, 0, 0, 0, 0, 0],
     [0, 0, 0, 1, 1, 1],
     [0, 0, 0, 0, 0, 0],
     [0, 0, 2, 0, 0, 0],
     [1, 1, 1, 0, 0, 0],
     [0, 0, 0, 0, 0, 0]
   ],
   "score": {},
   "fruitEaten": false
 }
 */

struct GameState: Codable, Equatable {
    var gameOver: Bool
    var message: String
    var snakes: [String: [Point]]
    var fruits: [Point]
    var score: [String: Int]
}
