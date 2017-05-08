//
//  GameScene.swift
//  p08ademola
//
//  Created by Lynda on 5/6/17.
//  Copyright © 2017 Lynda. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var groundMap:SKTileMapNode!
    var player:Player!
    var enemy:Entity!
    
    let groundNode = SKNode()
    var newPlayerPos = CGFloat(0)
    var playerJump = false
    
    override func didMove(to view: SKView) {
        print("GameScene()")
        groundNode.position = CGPoint(x: -669, y: -280)
        groundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1334, height: 190) , center: CGPoint(x:1334/2, y:0))
        groundNode.physicsBody?.affectedByGravity = false
        groundNode.physicsBody?.allowsRotation = false
        groundNode.physicsBody?.isDynamic = false
        addChild(groundNode)
        
        guard let groundMap = childNode(withName: "GroundMap") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        self.groundMap = groundMap
        
        setupPlayer()
    }
    
    func setupPlayer() {
        player = Player(imageName: "Idle (1)", scale: 0.25)
        addChild(player)
        enemy = Entity(imageName: "Tree_2", scale: 0.25)
        addChild(enemy)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        
        if(touch.tapCount == 2) {
            print("jump")
            //player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 30.0))
            player.jump(scene: self)
            playerJump = true
        } else if(touch.tapCount == 1) {
            print("%f", currentPoint.x)
            newPlayerPos = currentPoint.x
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        groundMap.position = CGPoint(x: groundMap.position.x - 5, y: groundMap.position.y)
        player.moveX(scene: self, xPosition: newPlayerPos)
        if(playerJump) {
            playerJump = false
            
            //player.jump(scene: self)
        }
    }
}
