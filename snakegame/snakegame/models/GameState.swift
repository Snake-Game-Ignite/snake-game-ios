//
//  GameState.swift
//  snakegame
//
//  Created by Vlad Z on 21/01/2024.
//

import Foundation

/*
{
 "status":true,
 "fruit":[{"x":2.0,"y":5.0}],
 "snakes":[
    {"id":1,"score":0,"snake":[{"x":1.0,"y":5.0},{"x":1.0,"y":6.0},{"x":1.0,"y":7.0},{"x":1.0,"y":8.0}]},
    {"id":2,"score":0,"snake":[{"x":8.0,"y":5.0},{"x":8.0,"y":6.0},{"x":8.0,"y":7.0},{"x":8.0,"y":8.0}]}]}
 */

struct GameState: Codable, Equatable {
    var status: Bool
    var snakes: [Player]
    var fruit: [Point]
}
