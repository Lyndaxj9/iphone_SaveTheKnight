//
//  Entity.swift
//  p08ademola
//
//  Created by Lynda on 5/6/17.
//  Copyright © 2017 Lynda. All rights reserved.
//

import SpriteKit

class Entity: SKSpriteNode {

    var walkingSpeed = CGFloat(100)
    var jumpHeight = CGFloat(300)
    var entityLeft = false
    var entityRight = false
    var entityMovement = false
    var health:Health!
    
    init(imageName: String, scale: CGFloat) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.green, size: texture.size())
        self.xScale = scale
        self.yScale = scale
        
        let textureSize = texture.size()
        let xSize = textureSize.width * scale
        let ySize = textureSize.height * scale
        self.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: xSize, height: ySize))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        health = Health(maxHealth: 100)
    }
    
    init() {
        let texture = SKTexture(imageNamed: "sign_1")
        super.init(texture: texture, color: UIColor.green, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func moveX(scene: SKScene, xPosition: CGFloat) {
        
        if(abs(self.position.x - xPosition) < walkingSpeed) {
            self.position.x = xPosition
        } else if(abs(self.position.x - xPosition) >= walkingSpeed) {
            if(self.position.x > xPosition){
                if(self.xScale > 0) {
                    self.xScale *= -1
                }
                //walking left
                self.position.x -= walkingSpeed
                entityLeft = true
                entityRight = false
                entityMovement = true
            } else if(self.position.x < xPosition){
                if(self.xScale < 0) {
                    self.xScale *= -1
                }
                self.position.x += walkingSpeed
                entityRight = true
                entityLeft = false
                entityMovement = true
            }
        } else {
            entityMovement = false
        }
    }
    
    func jump(scene: SKScene) {
        let jumpUpAction = SKAction.moveBy(x: 0, y: jumpHeight, duration: 0.4)
        let jumpDownAction = SKAction.moveBy(x: 0, y: -jumpHeight, duration: 0.5)
        let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
        self.run(jumpSequence)
        /*
        self.run(jumpSequence, completion: {
            self.physicsBody?.affectedByGravity = true
        })*/
        //print("jump method")
    }
}
