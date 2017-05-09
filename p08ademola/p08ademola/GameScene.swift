//
//  GameScene.swift
//  p08ademola
//
//  Created by Lynda on 5/6/17.
//  Copyright © 2017 Lynda. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None     : UInt32 = 0
    static let All      : UInt32 = UInt32.max
    static let Player : UInt32 = 0b1 //1
    static let Enemy  : UInt32 = 0b10 //2
    static let Platform : UInt32 = 0b11 //3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //map level
    var groundMap:SKTileMapNode!
    let groundNode = SKNode()
    let groundWidth = CGFloat(1334)
    let groundHeight = CGFloat(128)
    var halfSceneSize:CGFloat = 0.0
    var cam:SKCameraNode!
    
    //player
    var player:Player!
    var newPlayerPos = CGFloat(0)
    
    //enemy
    var enemy:Enemy!
    var enemiesArr = [Enemy]()
    
    override func didMove(to view: SKView) {
        print("GameScene()")
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        halfSceneSize = (scene?.frame.size.height)!/2
        cam = childNode(withName: "cam") as! SKCameraNode!
        self.camera = cam
        //addChild(cam)
        //cam.position = CGPoint(x: self.frame.midX , y: self.frame.midY)
        
        setupNodes()
        setupPlayer()
        setupEnemy()
    }
    
    func setupPlayer() {
        player = Player(imageName: "Idle (1)", scale: 0.20)
        let PdistanceFromBottom = groundHeight + player.size.height/2
        player.position.y = CGFloat(-(halfSceneSize - PdistanceFromBottom))
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(player)
    }
    
    func setupEnemy() {
        for i in 0..<5 {
            print("in loop")
            let anEnemy:Enemy = Enemy(imageName: "Idle__000", scale: 0.25)
            
            let EdistanceFromBottom = groundHeight + anEnemy.size.height/2
            anEnemy.position.y = CGFloat(-(halfSceneSize - EdistanceFromBottom))
            let randomX = CGFloat(arc4random_uniform(UInt32(groundMap.mapSize.width))) - groundWidth/2
            anEnemy.position.x = CGFloat(randomX)
            
            anEnemy.name = String(format: "enemy0%d", i)
            
            anEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
            anEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.Player
            anEnemy.physicsBody?.usesPreciseCollisionDetection = true
            
            addChild(anEnemy)
            enemiesArr.append(anEnemy)
        }
 
    }
    
    func setupNodes() {
        guard let groundMap = childNode(withName: "GroundMap") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        self.groundMap = groundMap
        
        groundNode.position = CGPoint(x: -669, y: -310)
        groundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: groundMap.mapSize.width/2, height: groundHeight) , center: CGPoint(x:groundMap.mapSize.width/4, y:0))
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
            //let moveCamera = SKAction.moveTo(x: newPlayerPos/2, duration: 0.9)
            //cam.run(moveCamera, withKey: "cameraMove")
        }
    }
    
    func moveCam() {
        if(cam.position.x < player.position.x) {
            if(player.position.x - 15 < cam.position.x)
            {
                cam.position.x = player.position.x
            } else {
                cam.position.x += 15
            }
        } else if(cam.position.x > player.position.x) {
            if(player.position.x + 15 > cam.position.x){
                cam.position.x = player.position.x
            } else {
                cam.position.x -= 15
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact!")
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.moveX(scene: self, xPosition: newPlayerPos)
        moveCam()
        for e in enemiesArr {
            e.followPlayer(scene: self, playerPos: player.position)
        }
    }
}
