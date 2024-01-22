//
//  GameView.swift
//  snakegame
//
//  Created by David Southgate on 22/01/2024.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    var scene: GameScene = {
        let scene = SKScene(fileNamed: "GameScene") as! GameScene
        scene.scaleMode = .aspectFill
        return scene
    }()

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Group {
                    VStack(spacing: 10) {
                        Button("⬆️") {
                            scene.move(direction: .up)
                        }
                        HStack(spacing: 30) {
                            Button("⬅️") {
                                scene.move(direction: .left)
                            }
                            Button("➡️") {
                                scene.move(direction: .right)
                            }
                        }
                        Button("⬇️") {
                            scene.move(direction: .down)
                        }
                    }
                }
                .font(.largeTitle)
            }
        }
    }
}
