//
//  GameScene.swift
//  Proj4Ships
//
//  Original concept by Joel Hollingsworth on 4/4/21
//  Modified by Duke Hutchings on 3/26/24
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playerShip = Ship()
    var shipData = [ShipPosition]()
    var ghostShips = [GhostShip]()
    var ghostTime = 0.0
    
    var coinRadius = 10.0
    var coinTime = 0.0
    var collectedCoinsCount = 0
    let coinCollectedSound = SKAction.playSoundFileNamed("zapThreeToneUp.mp3", waitForCompletion: false)
    var collectedCoinsCountLabel = SKLabelNode(text: "Coins: 0")
    
    var currentTouches = Set<UITouch>()
    
    var isGameOver = false
    
    // didMove()
    override func didMove(to view: SKView) {
        
        collectedCoinsCountLabel.position = CGPoint(x: 100, y: 150)
        addChild(collectedCoinsCountLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        playerShip.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playerShip)
        
        createACoin()
        
    }
    
    // contact control
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ship" && nodeB.name == "coin" {
            removeACoin(contactedCoin: nodeB)
        } else if nodeA.name == "coin" && nodeB.name == "ship" {
            removeACoin(contactedCoin: nodeA)
        } else if (nodeA.name == "ship" && nodeB.name == "ghost") || (nodeA.name == "ghost" && nodeB.name == "ship") {
            isGameOver = true
            let gameOverLabel = SKLabelNode(text: "Game Over!")
            gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(gameOverLabel)
        }
        
    }
    
    // touches began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            currentTouches.insert(touch)
        }
    }
    
    // touches ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            currentTouches.remove(touch)
        }
    }
    
    // update()
    override func update(_ currentTime: TimeInterval) {
        
        if isGameOver { return }
        
        self.view?.showsFPS = true
        
        // manage coin spawning 
        if (coinTime == 0.0) {
            coinTime = currentTime
            ghostTime = currentTime
        } else if (coinTime != 0.0 && coinTime + 10 < currentTime) {
            createACoin()
            coinTime = currentTime
        }
        
        // spawn a ghost ship
        if ghostTime != 0.0 && ghostTime + 8 < currentTime {
            let newGhostShip = GhostShip()
            if (newGhostShip.currentMove == 0) {
                newGhostShip.numberOfMovements = shipData.count
            }
            newGhostShip.updateGhostShipMovement(newShipData: shipData)
            ghostShips.append(newGhostShip)
            addChild(newGhostShip)
            ghostTime += 8
        }
        
        // move the player ship
        playerShip.steerShip(gameScreen: frame)
        let collectedShipData = ShipPosition(currentPosition: playerShip.position, currentZRotation: playerShip.zRotation)
        shipData.append(collectedShipData)
        
        // move the ghost ships
        for ghost in ghostShips {
            if (ghost.currentMove == ghost.numberOfMovements) {
                ghost.removeFromParent()
            }
            ghost.updateGhostShipMovement(newShipData: shipData)
        }
        
        // touch control
        for touch in currentTouches {
            if touch.location(in: self).x < frame.midX {
                playerShip.turnShipLeft()
            } else {
                playerShip.turnShipRight()
            }
        }
        
    }
    
    // create a coin
    func createACoin() {
        
        let coin = SKShapeNode(circleOfRadius: coinRadius)
        coin.fillColor = .white
        coin.strokeColor = .white
        coin.position.x = CGFloat.random(in: (coinRadius * 2)...frame.maxX - (coinRadius * 2))
        coin.position.y = CGFloat.random(in: (coinRadius * 2)...frame.maxY - (coinRadius * 2))
        
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coinRadius)
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.collisionBitMask = 0b0000
        coin.physicsBody?.contactTestBitMask = 0b0001
        
        coin.name = "coin"
        addChild(coin)
        
    }
    
    // remove a coin
    func removeACoin(contactedCoin: SKNode) {
        
        collectedCoinsCount += 1
        collectedCoinsCountLabel.text = String("Coins: \(collectedCoinsCount)")
        
        run(coinCollectedSound)
        
        contactedCoin.removeFromParent()
        
        if collectedCoinsCount == 15 {
            isGameOver = true
            let gameOverLabel = SKLabelNode(text: "Game Over!")
            gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(gameOverLabel)
        }
        
    }
    
}
