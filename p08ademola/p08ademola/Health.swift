//
//  Health.swift
//  p08ademola
//
//  Created by Lynda on 5/9/17.
//  Copyright © 2017 Lynda. All rights reserved.
//

import UIKit

class Health: NSObject {
    
    var maxhealth:CGFloat
    var current:CGFloat
    
    init(maxHealth: CGFloat) {
        maxhealth = maxHealth
        current = maxHealth
    }
    
    func damageHealth(damage: CGFloat) {
        if(damage > 0){
            current = max(0, (current - damage))
        } else {
            current = min(maxhealth, current - damage);
        }
    }
}
