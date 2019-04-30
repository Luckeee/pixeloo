//
//  pixel.swift
//  pixeloo
//
//  Created by hata on 2019/4/30.
//  Copyright © 2019 hata. All rights reserved.
//

import Foundation
import SpriteKit

class Pixel: SKShapeNode {
    
    override init() {
        super.init()
        
        self.fillColor = .white
        self.strokeColor = UIColor.gray
        
        // FIXME: Adjust line width to scroll rate
        self.lineWidth = 1
        
        let rect = UIBezierPath(rect: CGRect(x: 0, y: 0, width: PIXEL_SIZE, height: PIXEL_SIZE))
        self.path = rect.cgPath
        self.isUserInteractionEnabled = true
        self.isAntialiased = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Point{
    
    var x : Int = 0
    var y : Int = 0
    
    init(cgpoint : CGPoint) {
        x = Int(floor(cgpoint.x / CGFloat(PIXEL_SIZE)))
        y  = Int(floor(cgpoint.y / CGFloat(PIXEL_SIZE)))
    }
    
    func distance(q : Point) -> Int {
        let a = q.x - x
        let b = q.y - y
        let c = a * a
        let d = b * b
        
        if d > c {
            if b > 0 {
                return b
            }else{
                return b * -1
            }
        }else{
            if a > 0 {
                return a
            }else{
                return a * -1
            }
        }
    }
}
