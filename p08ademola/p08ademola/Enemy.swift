//
//  Enemy.swift
//  p08ademola
//
//  Created by Lynda on 5/8/17.
//  Copyright © 2017 Lynda. All rights reserved.
//

import UIKit
import SpriteKit

class Enemy: Entity {

    private let agroDistance = CGFloat(250)
    private var idling = true
    private var attacking = false
    
    override init(imageName: String, scale: CGFloat) {
        super.init(imageName: imageName, scale: scale)
        self.position = CGPoint(x: -100, y: 0)
        self.walkingSpeed = 130
        idleMove()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func idleMove() {
        let leftWalk = SKAction.moveBy(x: -walkingSpeed, y: 0, duration: 1.5)
        let rightWalk = SKAction.moveBy(x: walkingSpeed, y: 0, duration: 1.5)
        let idleWalkSeq = SKAction.sequence([leftWalk, rightWalk])
        //self.run(SKAction.repeatForever(idleWalkSeq))
        self.run(SKAction.repeatForever(idleWalkSeq), withKey: "idling")
    }
    
    func followPlayer(scene: SKScene, playerPos: CGPoint) {
        let distanceX = playerPos.x - self.position.x
        let distanceY = playerPos.y - self.position.y
        
        let distanceTotal = sqrt(distanceX*distanceX + distanceY*distanceY)
        
        if(distanceTotal < agroDistance){
            if(!attacking) {
                self.removeAction(forKey: "idling")
                print("attack")
                attacking = true
                idling = false
            }
        } else if(distanceTotal >= agroDistance) {
            attacking = false
            if(!idling && !attacking) {
                idleMove()
                idling = true
            }
        }
    }
}
