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
    //static let Prince : UInt32 = 0b11 //3
    static let PointObject: UInt32 = 0b100 //4
    static let PlayerBullet: UInt32 = 0b101 //5
    static let EnemyBullet: UInt32 = 0b110 //6
    //static let Prince:  UInt32 = 0b111 //7
    static let Prince: UInt32 = 0b1000 //8
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
    var gameOver = false
    
    //gui
    var scoreLabel:SKLabelNode!
    var score = 0
    var healthContainer:SKSpriteNode!
    var healthBar:SKSpriteNode!
    let healthCropNode = SKCropNode()
    var mask:SKSpriteNode!
    var youLose:SKLabelNode!
    var youWin:SKLabelNode!
    
    //player
    var player:Player!
    var newPlayerPos = CGFloat(0)
    var playerHealth:Health!
    
    var prince:Player!
    
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
        setupPrince()
    }
    
    func setupPlayer() {
        player = Player(imageName: "Idle (1)", scale: 0.20)
        let PdistanceFromBottom = groundHeight + player.size.height/2
        player.position.y = CGFloat(-(halfSceneSize - PdistanceFromBottom))
        player.name = "player"
        
        playerHealth = player.health
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.PointObject | PhysicsCategory.Prince
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(player)
    }
    
    func setupPrince() {
        prince = Player(imageName: "Idle02", scale: 0.20)
        prince.position = CGPoint(x: 2500, y: 200)
        prince.name = "prince"
        prince.xScale *= -1
        
        prince.physicsBody?.categoryBitMask = PhysicsCategory.Prince
        prince.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        prince.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(prince)
    }
    
    func setupEnemy() {
        for _ in 0..<5 {
            let anEnemy:Enemy = Enemy(imageName: "Walk (3)", scale: 0.25)
            
            let EdistanceFromBottom = groundHeight + anEnemy.size.height/2
            anEnemy.position.y = CGFloat(-(halfSceneSize - EdistanceFromBottom))
            let randomX = CGFloat(arc4random_uniform(UInt32(groundMap.mapSize.width/2))) - groundWidth/2
            anEnemy.position.x = CGFloat(randomX)
            
            //anEnemy.name = String(format: "enemy0%d", i)
            anEnemy.name = "enemy"
            
            anEnemy.bullet.physicsBody?.categoryBitMask = PhysicsCategory.EnemyBullet
            anEnemy.bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Player
            
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
 
        scoreLabel = cam.childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel.text = "0"
        
        youWin = cam.childNode(withName: "youWin") as? SKLabelNode
        youLose = cam.childNode(withName: "youLose") as? SKLabelNode
        
        healthContainer = cam.childNode(withName: "healthContainer") as? SKSpriteNode
        healthBar = healthContainer.childNode(withName: "healthBar") as? SKSpriteNode
        //let mask = SKSpriteNode(color: UIColor.black, size: CGSize(width: healthBar.frame.size.width, height: healthBar.frame.size.height))
        let maskSize = healthBar.texture!.size()
        //print("maskSize w:", maskSize.width, "maskSize h:", maskSize.height)
        let mask = SKSpriteNode(texture: healthBar.texture, size: CGSize(width: maskSize.width, height: maskSize.height))
        mask.setScale(1.25)
        //mask.position = CGPoint(x:0, y: 0)
        healthBar.removeFromParent()
        healthCropNode.maskNode = mask
        healthCropNode.addChild(healthBar)
        healthBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        healthBar.position.x = healthBar.position.x - healthBar.size.width/2
        healthContainer.addChild(healthCropNode)
        healthCropNode.zPosition = 5
        healthBar.zPosition = 5
        
        

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
        if(player.position.x > 0){
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
    }
    
    func restartGame() {
        for aE in enemiesArr {
            if(intersects(aE)) {
                aE.removeFromParent()
            }
        }
        
        player.removeFromParent()
        prince.removeFromParent()
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
                        playerHealth.damageHealth(damage: -7.0)
                        let barDisplay = playerHealth.current/playerHealth.maxhealth
                        healthBar.xScale = barDisplay
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
                //print("got point")
                var crate:SKNode? = nil
                
                if(contact.bodyA.node?.name == "player") {
                    crate = contact.bodyB.node
                    if(contact.bodyB.node == nil){
                    }
                } else {
                    crate = contact.bodyA.node
                    if(contact.bodyA.node == nil){
                    }
                }
                
                if(crate != nil){
                    score += 10
                    scoreLabel.text = String(format: "%d", score)
                    playerHealth.damageHealth(damage: -3.0)
                    let barDisplay = playerHealth.current/playerHealth.maxhealth
                    healthBar.xScale = barDisplay
                }
                crate?.removeFromParent()
                //print(score)
                break
 
            case PhysicsCategory.Player | PhysicsCategory.EnemyBullet:
                if(contact.bodyA.node?.name == "player") {
                    if(contact.bodyA.node?.intersects(contact.bodyB.node!))! {
                        contact.bodyB.node?.physicsBody?.categoryBitMask = PhysicsCategory.None
                        print("bullet hit player")
                        playerHealth.damageHealth(damage: 5.0)
                        let barDisplay = playerHealth.current/playerHealth.maxhealth
                        healthBar.xScale = barDisplay
                    }
                }
                break
                
            case PhysicsCategory.Player | PhysicsCategory.Prince:
                print("You Win")
                gameOver = true
                if(gameOver){
                    youWin.isHidden = false
                }
                break
            
            default:
                break
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(!gameOver){
            player.moveX(scene: self, xPosition: newPlayerPos)
            moveCam()
            for e in enemiesArr {
                e.followPlayer(scene: self, playerPos: player.position)
            }
            if(playerHealth.current <= 0){
                gameOver = true
                youLose.isHidden = false
            }
        }
        
    }
}
