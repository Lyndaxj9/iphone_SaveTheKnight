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
    static let PointObject: UInt32 = 0b100 //4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //map level
    var groundMap:SKTileMapNode!
    var objectTileMap:SKTileMapNode!
    let groundNode = SKNode()
    let groundWidth = CGFloat(1334)
    let groundHeight = CGFloat(128)
    var halfSceneSize:CGFloat = 0.0
    var cam:SKCameraNode!
    var score = 0
    
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
        player.name = "player"
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.PointObject
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(player)
    }
    
    func setupEnemy() {
        for _ in 0..<5 {
            let anEnemy:Enemy = Enemy(imageName: "Idle__000", scale: 0.25)
            
            let EdistanceFromBottom = groundHeight + anEnemy.size.height/2
            anEnemy.position.y = CGFloat(-(halfSceneSize - EdistanceFromBottom))
            let randomX = CGFloat(arc4random_uniform(UInt32(groundMap.mapSize.width/2))) - groundWidth/2
            anEnemy.position.x = CGFloat(randomX)
            
            //anEnemy.name = String(format: "enemy0%d", i)
            anEnemy.name = "enemy"
            
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
        
        
        guard let objectTileMap = childNode(withName: "ObjectMap") as? SKTileMapNode else {
            fatalError("Objects node not loaded")
        }
        self.objectTileMap = objectTileMap
 
        //tileMapPhysics(name: self.platformMap, dataString: "platform", categoryMask: PhysicsCategory.Platform)
    }
    
    func tileMapPhysics(name: SKTileMapNode, dataString: NSString, categoryMask: UInt32) {
        let tileMap = name
        //tileMap.anchorPoint = CGPoint(x: 0, y: 0.5)
        let tap = tileMap.anchorPoint
        print(tap.x, tap.y)
        
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns)/2.0 * tileSize.width //this confuses me
        let halfHeight = CGFloat(tileMap.numberOfRows)/2.0 * tileSize.height
        print("tilesize width: %f | tilesize height: %f", tileSize.width, tileSize.height)
        print("halfWidth: %f | halfHeight: %f", halfWidth, halfHeight)
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row) {
                    let isHitTile = tileDefinition.userData?[dataString] as? Int
                    if(isHitTile != 0) {
                        //print("tilehitget")
                        let tileArray = tileDefinition.textures
                        let tileTexture = tileArray[0]
                        
                        let x = CGFloat(col)*tileSize.width - halfWidth + (tileSize.width/2)
                        let y = CGFloat(row)*tileSize.height - halfHeight + (tileSize.height/2)
                        
                        let tileNode = SKNode()
                        
                        tileNode.position = CGPoint(x:x, y:y)
                        tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size:CGSize(width: (tileTexture.size().width), height: (tileTexture.size().height))) //why *2
                        tileNode.physicsBody?.linearDamping = 60.0
                        tileNode.physicsBody?.affectedByGravity = false
                        tileNode.physicsBody?.allowsRotation = false
                        tileNode.physicsBody?.restitution = 0.0
                        tileNode.physicsBody?.isDynamic = false
                        
                        /*
                        tileNode.physicsBody?.categoryBitMask = categoryMask
                        tileNode.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerRobot | PhysicsCategory.EnemyRobot
                        tileNode.physicsBody?.collisionBitMask = collisionMask
 */
                        tileNode.name = "platform"
                        tileNode.yScale = tileMap.yScale
                        tileNode.xScale = tileMap.xScale
                        
                        tileMap.addChild(tileNode)
                        //addChild(tileNode)
                    }
                }
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        
        if(touch.tapCount == 2) {
            //print("jump")
            player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 150.0))
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
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
            case PhysicsCategory.Player | PhysicsCategory.Enemy:
                if(contact.bodyA.node?.name == "player"){
                    let playerY = contact.bodyA.node?.position.y
                    let enemyY = contact.bodyB.node?.position.y
                    if(CGFloat(playerY!) > CGFloat(enemyY!)) {
                        print("player hit enemy A")
                        contact.bodyB.node?.removeFromParent()
                    }
                } else if(contact.bodyB.node?.name == "player"){
                    let playerY = contact.bodyB.node?.position.y
                    let enemyY = contact.bodyA.node?.position.y
                    if(CGFloat(playerY!) > CGFloat(enemyY!)) {
                        print("player hit enemy B")
                    }
                }
                break
            
            
            case PhysicsCategory.Player | PhysicsCategory.PointObject:
                print("got point")
                var crate:SKNode? = nil
                
                if(contact.bodyA.node?.name == "player") {
                    crate = contact.bodyB.node
                    if(contact.bodyB.node == nil){
                        //score += 10
                    }
                } else {
                    crate = contact.bodyA.node
                    if(contact.bodyA.node == nil){
                        //score += 10
                    }
                }
                
                if(crate != nil){
                    score += 10
                }
                crate?.removeFromParent()
                print(score)
                break
 
            
            default:
                break
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.moveX(scene: self, xPosition: newPlayerPos)
        moveCam()
        for e in enemiesArr {
            e.followPlayer(scene: self, playerPos: player.position)
        }
        
        //check if over crate
        let position = player.position
        
        let column = objectTileMap.tileColumnIndex(fromPosition: position)
        let row = objectTileMap.tileRowIndex(fromPosition: position)
        
        let objectTile = objectTileMap.tileDefinition(atColumn: column, row: row)
        
        if let _ = objectTile?.userData?.value(forKey: "crate") {
            objectTileMap.setTileGroup(nil, forColumn: column, row: row)
            score += 10
            print("score is: %d", score)
            //scoreLabel.text = String(format: "Score: %d", score)
        }
    }
}
