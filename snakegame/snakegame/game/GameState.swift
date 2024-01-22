//
//  GameState.swift
//  snakegame
//
//  Created by David Southgate on 22/01/2024.
//

import Foundation

/// The positions of all elements of the game
struct GameState: Equatable {
    let fruit: [Point]
    let snakes: [[Point]]
    
    static let initial = GameState(
        fruit: [Point(x: 3, y: 1), Point(x: 5, y: 5)],
        snakes: [
            [
                Point(x: 0, y: 0),
                Point(x: 1, y: 0)
            ],
            [
                Point(x: 4, y: 4),
                Point(x: 4, y: 5)
            ]
        ]
    )
}
