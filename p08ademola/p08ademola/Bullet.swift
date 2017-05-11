//
//  Bullet.swift
//  p08ademola
//
//  Created by Lynda on 5/10/17.
//  Copyright © 2017 Lynda. All rights reserved.
//

import UIKit
import SpriteKit

class Bullet: SKSpriteNode {
    
    init(bulletImage: String?) {
        let texture = SKTexture(imageNamed: bulletImage!)
        super.init(texture: texture, color: UIColor.blue, size: texture.size())
        self.name = "bullet"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
