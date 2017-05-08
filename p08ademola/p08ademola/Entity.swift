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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func moveX(scene: SKScene, xPosition: CGFloat) {
        
        if(abs(self.position.x - xPosition) < walkingSpeed) {
            self.position.x = xPosition
        } else {
            if(self.position.x > xPosition){
                self.position.x -= walkingSpeed
            } else if(self.position.x < xPosition){
                self.position.x += walkingSpeed
            }
        }
    }
    
    func jump(scene: SKScene) {
        //let jumpUpAction = SKAction.moveByX(0, y:20 duration:0.2)
        let jumpUpAction = SKAction.moveBy(x: 0, y: 20, duration: 0.2)
        let jumpDownAction = SKAction.moveBy(x: 0, y: 20, duration: 0.2)
        let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
        self.run(jumpSequence)
        print("jump method")
    }
}
