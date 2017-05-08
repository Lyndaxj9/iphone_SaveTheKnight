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
    var enemy:Enemy!
    
    let groundNode = SKNode()
    var newPlayerPos = CGFloat(0)
    var maxMapPos = CGFloat(-1000)
    var playerJump = false
    
    override func didMove(to view: SKView) {
        print("GameScene()")
        groundNode.position = CGPoint(x: -669, y: -310)
        groundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1334, height: 128) , center: CGPoint(x:1334/2, y:0))
        groundNode.physicsBody?.affectedByGravity = false
        groundNode.physicsBody?.allowsRotation = false
        groundNode.physicsBody?.isDynamic = false
        addChild(groundNode)
        
        guard let groundMap = childNode(withName: "GroundMap") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        self.groundMap = groundMap
        maxMapPos = -(groundMap.mapSize.width - self.frame.size.width/2)
        
        setupPlayer()
    }
    
    func setupPlayer() {
        player = Player(imageName: "Idle (1)", scale: 0.25)
        player.position.y = CGFloat(-((scene?.frame.size.height)!/2 - 190))
        addChild(player)
        enemy = Enemy(imageName: "Tree_2", scale: 0.25)
        addChild(enemy)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        
        if(touch.tapCount == 2) {
            //print("jump")
            //player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 30.0))
            player.jump(scene: self)
        } else if(touch.tapCount == 1) {
            //print("%f", currentPoint.x)
            newPlayerPos = currentPoint.x
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* figure out how to make the screen move only when the player moves
        if(groundMap.position.x > maxMapPos && player.entityMovement) {
            print("%f", maxMapPos)
            if(player.entityLeft){
                groundMap.position.x -= player.walkingSpeed
            } else if(player.entityRight) {
                groundMap.position.x += player.walkingSpeed
            }
        }
        */
        
        //groundMap.position = CGPoint(x: groundMap.position.x - 5, y: groundMap.position.y)
        player.moveX(scene: self, xPosition: newPlayerPos)
        enemy.followPlayer(scene: self, playerPos: player.position)
    }
}
