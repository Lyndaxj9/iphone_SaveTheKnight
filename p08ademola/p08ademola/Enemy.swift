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
    private let attackDistance = CGFloat(70)
    private var idling = true
    private var attacking = false
    private let idleSpeed = CGFloat(130)
    
    override init(imageName: String, scale: CGFloat) {
        super.init(imageName: imageName, scale: scale)
        self.position = CGPoint(x: -100, y: 0)
        self.walkingSpeed = 15
        idleMove()
    }
    
    override init() {
        super.init()
        self.walkingSpeed = 15
        idleMove()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func idleMove() {
        let leftWalk = SKAction.moveBy(x: -idleSpeed, y: 0, duration: 1.5)
        let rightWalk = SKAction.moveBy(x: idleSpeed, y: 0, duration: 1.5)
        let idleWalkSeq = SKAction.sequence([leftWalk, rightWalk])
        //self.run(SKAction.repeatForever(idleWalkSeq))
        self.run(SKAction.repeatForever(idleWalkSeq), withKey: "idling")
    }
    
    func getCloser(scene: SKScene, playerPos: CGPoint) {
        moveX(scene: scene, xPosition: playerPos.x)
    }
    
    func attack() {
        /*
        let attackAni = SKAction.moveBy(x: 0, y: 20, duration: 0.45)
        let attackAniDown = SKAction.moveBy(x: 0, y: -20, duration: 0.4)
        let attackSeq = SKAction.sequence([attackAni, attackAniDown])
        self.run(SKAction.repeatForever(attackSeq), withKey: "attacking")
        */
        
        let customAction = SKAction.run({
            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 10.0))
        })
        let attackSeq = SKAction.sequence([customAction, SKAction.wait(forDuration: 0.2)])
        self.run(SKAction.repeatForever(attackSeq), withKey: "attacking")
    }
    
    func followPlayer(scene: SKScene, playerPos: CGPoint) {
        let distanceX = playerPos.x - self.position.x
        let distanceY = playerPos.y - self.position.y
        
        let distanceTotal = sqrt(distanceX*distanceX + distanceY*distanceY)
        
        if(distanceTotal < attackDistance) {
            if(!attacking) {
                self.removeAction(forKey: "idling")
                print("attack")
                attack()
                attacking = true
                idling = false
            }
        } else if(distanceTotal < agroDistance && distanceTotal > attackDistance){
            getCloser(scene: scene, playerPos: playerPos)
        } else if(distanceTotal >= agroDistance) {
            attacking = false
            if(!idling && !attacking) {
                self.removeAction(forKey: "attacking")
                idleMove()
                idling = true
            }
        }
    }
}
