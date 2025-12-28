//
//  GhostShip.swift
//  Proj4Ships
//
//  Created by Jeremiah Timberlake on 4/9/24.
//

import Foundation

class GhostShip: Ship {
    
    var currentMove = 0 
    var numberOfMovements = 0;
    
    override init() {
        
        super.init()
        
        self.fillColor = .gray
        self.name = "ghost"
        self.physicsBody?.isDynamic = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // update the ghost ship to follow the player ship
    func updateGhostShipMovement(newShipData: [ShipPosition]) {
        self.position.x = newShipData[currentMove].currentPosition.x
        self.position.y = newShipData[currentMove].currentPosition.y
        self.zRotation = newShipData[currentMove].currentZRotation
        currentMove += 1
    }
    
}
