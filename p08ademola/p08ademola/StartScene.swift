//
//  StartScene.swift
//  p08ademola
//
//  Created by Lynda on 5/6/17.
//  Copyright © 2017 Lynda. All rights reserved.
//

import GameplayKit
import SpriteKit

class StartScene: SKScene {

    override func sceneDidLoad() {
        //initalize stuff?
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            let touchedNode = nodes(at: location)
            
            if touchedNode[0].name == "nextButton" {
                let transition = SKTransition.reveal(with: .down, duration: 1.0)
                
                let nextScene = SKScene(fileNamed: "IntroScene")
                //let nextScene = InstructScene
                nextScene?.scaleMode = .aspectFill
                
                scene?.view?.presentScene(nextScene!, transition: transition)
            }
        }

    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
