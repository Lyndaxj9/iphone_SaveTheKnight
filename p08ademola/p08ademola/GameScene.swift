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
    
    let groundNode = SKNode()
    
    override func didMove(to view: SKView) {
        print("GameScene()")
        groundNode.position = CGPoint(x: -669, y: -280)
        groundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1334, height: 190) , center: CGPoint(x:1334/2, y:0))
        groundNode.physicsBody?.affectedByGravity = false
        groundNode.physicsBody?.allowsRotation = false
        addChild(groundNode)
        
        guard let groundMap = childNode(withName: "GroundMap") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        self.groundMap = groundMap
    }
    
    override func update(_ currentTime: TimeInterval) {
        groundMap.position = CGPoint(x: groundMap.position.x - 5, y: groundMap.position.y)
    }
}
