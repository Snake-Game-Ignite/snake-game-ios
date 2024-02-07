//
//  GameView.swift
//  snakegame
//
//  Created by David Southgate on 22/01/2024.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    @State
    var viewModel = GameViewModel(rows: GameScene.rows, cols: GameScene.cols)
    
    @State
    var scene: GameScene
    
    @State private var favoriteColor = 0
    
    init() {
        let viewModel = GameViewModel(rows: GameScene.rows, cols: GameScene.cols)
        self.viewModel = viewModel
        let scene = SKScene(fileNamed: "GameScene") as! GameScene
        scene.scaleMode = .aspectFill
        scene.viewModel = viewModel
        self.scene = scene
    }

    var body: some View {
        @Bindable var viewModel = viewModel
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            VStack {
                Text(viewModel.state?.message ?? "")
                    .foregroundStyle(.white)
                Button("Reset") {
                    viewModel.reset()
                }
                Text("Current Scores")
                        .foregroundStyle(.white)
                Text("iOS Fruits: \(viewModel.state?.score["ios"] ?? 0), Android Fruits: \(viewModel.state?.score["android"] ?? 0)")
                        .foregroundStyle(.green)
                Text("iOS Deaths: \(viewModel.state?.deaths["ios"] ?? 0), Android Deaths: \(viewModel.state?.deaths["android"] ?? 0)")
                        .foregroundStyle(.red)
                Picker("", selection: $viewModel.player) {
                    Text("Player 1").tag(1)
                    Text("Player 2").tag(2)
                    Text("Player 3").tag(3)
                }
                .pickerStyle(.segmented)
                .preferredColorScheme(.dark)
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
                .background(Color(viewModel.color))
            }
        }
    }
}
