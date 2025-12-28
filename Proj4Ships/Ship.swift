//
//  Ship.swift
//  Proj4Ships
//
//  Created by Jeremiah Timberlake on 4/6/24.
//

import SpriteKit

class Ship: SKShapeNode {
    
    let shipWidth = 10.0
    let shipSpeed = 125.00 // DESCRIPTIVE NAME CHANGE
    let shipRotationAngle = CGFloat.pi / 80.0
    
    override init() {
        
        super.init()
        
        let shipShape = UIBezierPath()
        shipShape.move(to: CGPoint(x: 0.0, y: shipWidth * 2.0))
        shipShape.addLine(to: CGPoint(x: -shipWidth, y: -shipWidth * 2.0))
        shipShape.addLine(to: CGPoint(x: shipWidth, y: -shipWidth * 2.0))
        shipShape.addLine(to: CGPoint(x: 0.0, y: shipWidth * 2.0))
        self.path = shipShape.cgPath
        
        self.fillColor = .orange
        self.strokeColor = .white
        self.glowWidth = 1.0
        self.isAntialiased = true
        
        self.physicsBody = SKPhysicsBody(polygonFrom: shipShape.cgPath)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // steer the ship
    func steerShip(gameScreen: CGRect) {
        
        // steer the ship in the direction it is pointing
        let shipAngle = Double(zRotation + CGFloat.pi / 2.0)
        let shipVelocityX = CGFloat(shipSpeed * cos(shipAngle))
        let shipVelocityY = CGFloat(shipSpeed * sin(shipAngle))
        self.physicsBody?.velocity = CGVector(dx: shipVelocityX, dy: shipVelocityY)
        self.physicsBody?.collisionBitMask = 0b0000
        self.physicsBody?.contactTestBitMask = 0b0001
        self.name = "ship"
        
        // teleport the ship to the opposite side if it leaves on one side
        
        // leaves on the right --> teleports to the left
        if self.position.x - CGFloat(shipWidth * 2.0) > gameScreen.maxX {
            let teleportLeftAction = SKAction.moveTo(x: CGFloat(CGFloat(gameScreen.minX - (shipWidth * 2.0))), duration: 0.0)
            self.run(teleportLeftAction)
        }
        
        // leaves on the left --> teleports to the right
        if self.position.x + CGFloat(shipWidth * 2.0) < gameScreen.minX {
            let teleportRightAction = SKAction.moveTo(x: CGFloat(CGFloat(gameScreen.maxX + (shipWidth * 2.0))), duration: 0.0)
            self.run(teleportRightAction)
        }
        
        // leaves on the top --> teleports to the bottom
        if self.position.y - CGFloat(shipWidth * 2.0) > gameScreen.maxY {
            let teleportBottomAction = SKAction.moveTo(y: CGFloat(CGFloat(gameScreen.minY - (shipWidth * 2.0))), duration: 0.0)
            self.run(teleportBottomAction)
        }
        
        // leaves on the bottom --> teleports to the top
        if self.position.y + CGFloat(shipWidth * 2.0) < gameScreen.minY {
            let teleportTopAction = SKAction.moveTo(y: CGFloat(CGFloat(gameScreen.maxY + (shipWidth * 2.0))), duration: 0.0)
            self.run(teleportTopAction)
        }
        
    }
    
    // rotate the ship to the left
    func turnShipLeft() {
        let turnLeftAction = SKAction.rotate(byAngle: shipRotationAngle, duration: 0.25) // LITERAL FLAW FIX --> It would be good to create a global
        self.run(turnLeftAction)                                                         // shipRotationAngle instead of of using a literal, because its
    }                                                                                    // value gets used twice in two separate functions: turnShipLeft()
                                                                                         // and turnShipRight(). Changes to that value might want to be made
    // rotate the ship to the right                                                      // later, so this approach makes it easier rather than going to
    func turnShipRight() {                                                               // the individual functions and recalculating it there twice.
        let turnRightAction = SKAction.rotate(byAngle: -shipRotationAngle, duration: 0.25) // LITERAL FLAW FIX
        self.run(turnRightAction)
    }
    
}
