//
//  IntroScene.swift
//  p08ademola
//
//  Created by Lynda on 5/6/17.
//  Copyright © 2017 Lynda. All rights reserved.
//

import SpriteKit

class IntroScene: SKScene {
    override func didMove(to view: SKView) {
        print("IntroScene()")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            let touchedNode = nodes(at: location)
            
            if(touchedNode.count != 0){
                if touchedNode[0].name == "startButton" {
                    let transition = SKTransition.reveal(with: .down, duration: 1.0)
                    
                    let nextScene = SKScene(fileNamed: "GameScene")
                    //let nextScene = InstructScene
                    nextScene?.scaleMode = .aspectFill
                    
                    scene?.view?.presentScene(nextScene!, transition: transition)
                }
            }
        }
        
    }
}
