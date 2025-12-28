//
//  GameView.swift
//  Proj4Ships
//
//  Original concept by Joel Hollingsworth on 4/4/21
//  Modified by Duke Hutchings on 3/26/24.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
    var gameScene: SKScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: gameScene)
    }
    
}

#Preview {
    GameView()
}
