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

    private let agroDistance = CGFloat(375)
    private let attackDistance = CGFloat(250)
    private var idling = true
    private var attacking = false
    private let idleSpeed = CGFloat(130)
    private var canFire = true
    var bullet = Bullet(bulletImage: "Bone (3)")
    
    override init(imageName: String, scale: CGFloat) {
        super.init(imageName: imageName, scale: scale)
        self.position = CGPoint(x: -100, y: 0)
        self.walkingSpeed = 10
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
    
    func fireBullet(scene: SKScene, location: CGPoint) {
        if(!canFire){
            return
        } else {
            canFire = false
            
            bullet = Bullet(bulletImage: "Bone (3)")
            bullet.setScale(0.4)
            
            bullet.position.x = self.position.x + self.size.width/2
            bullet.position.y = self.position.y
            
            let bulletSize = bullet.texture?.size()
            let xSize = (bulletSize?.width)! * bullet.xScale
            let ySize = (bulletSize?.height)! * bullet.yScale
            bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: CGSize(width: xSize, height: ySize))
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.allowsRotation = true
            bullet.physicsBody?.affectedByGravity = true
            bullet.physicsBody?.categoryBitMask = PhysicsCategory.EnemyBullet
            bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Player
            
            scene.addChild(bullet)
            
            let moveBulletAction = SKAction.move(to: CGPoint(x:location.x, y:self.position.y), duration: 1.0)
            let removeBulletAction = SKAction.removeFromParent()
            
            bullet.run(SKAction.sequence([moveBulletAction, removeBulletAction]))
            let waitToEnableFire = SKAction.wait(forDuration: 0.5)
            run(waitToEnableFire, completion: {
                self.canFire = true
            })
            
            print("shoot bullet")
        }
    }
    
    func attack(scene: SKScene, playerPos: CGPoint) {
        fireBullet(scene: scene, location: playerPos)
    }
    
    func followPlayer(scene: SKScene, playerPos: CGPoint) {
        let distanceX = playerPos.x - self.position.x
        let distanceY = playerPos.y - self.position.y
        
        let distanceTotal = sqrt(distanceX*distanceX + distanceY*distanceY)
        
        if(distanceTotal < attackDistance) {
            //if(!attacking) {
                self.removeAction(forKey: "idling")
                print("attack")
                attack(scene: scene, playerPos: playerPos)
                attacking = true
                idling = false
            //}
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
