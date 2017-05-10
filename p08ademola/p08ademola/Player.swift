//
//  Player.swift
//  p08ademola
//
//  Created by Lynda on 5/7/17.
//  Copyright © 2017 Lynda. All rights reserved.
//

import UIKit
import SpriteKit

class Player: Entity {

    override init(imageName: String, scale: CGFloat) {
        super.init(imageName: imageName, scale: scale)
        self.position = CGPoint(x: 0, y: 0)
        self.walkingSpeed = 20
        self.entityLeft = false
        self.entityRight = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
