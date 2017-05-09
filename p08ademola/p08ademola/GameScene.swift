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
    let groundWidth = CGFloat(1334)
    let groundHeight = CGFloat(128)
    var cam:SKCameraNode!
    var newPlayerPos = CGFloat(0)
    var maxMapPos = CGFloat(-1000)
    var playerJump = false
    
    override func didMove(to view: SKView) {
        print("GameScene()")
        cam = childNode(withName: "cam") as! SKCameraNode!
        //cam.setScale(0.9)
        self.camera = cam
        //addChild(cam)
        //cam.position = CGPoint(x: self.frame.midX , y: self.frame.midY)
        
        setupNodes()
        setupPlayer()
    }
    
    func setupPlayer() {
        let halfSceneSize = (scene?.frame.size.height)!/2
        player = Player(imageName: "Idle (1)", scale: 0.20)
        let PdistanceFromBottom = groundHeight + player.size.height/2
        player.position.y = CGFloat(-(halfSceneSize - PdistanceFromBottom))
        addChild(player)
        
        enemy = Enemy(imageName: "Tree_2", scale: 0.25)
        let EdistanceFromBottom = groundHeight + enemy.size.height/2
        enemy.position.y = CGFloat(-(halfSceneSize - EdistanceFromBottom))
        addChild(enemy)
    }
    
    func setupNodes() {
        guard let groundMap = childNode(withName: "GroundMap") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        self.groundMap = groundMap
        
        groundNode.position = CGPoint(x: -669, y: -310)
        groundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: groundMap.mapSize.width, height: groundHeight) , center: CGPoint(x:1334/2, y:0))
        groundNode.physicsBody?.affectedByGravity = false
        groundNode.physicsBody?.allowsRotation = false
        groundNode.physicsBody?.isDynamic = false
        addChild(groundNode)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        
        if(touch.tapCount == 2) {
            //print("jump")
            player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 120.0))
            //player.jump(scene: self)
        } else if(touch.tapCount == 1) {
            //print("%f", currentPoint.x)
            newPlayerPos = currentPoint.x
            let moveCamera = SKAction.moveTo(x: newPlayerPos/2, duration: 0.9)
            cam.run(moveCamera, withKey: "cameraMove")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.moveX(scene: self, xPosition: newPlayerPos)
        enemy.followPlayer(scene: self, playerPos: player.position)
    }
}
