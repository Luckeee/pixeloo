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
        self.strokeColor = UIColor.black
        
        // FIXME: Adjust line width to scroll rate
        self.lineWidth = 0.5
        
        let rect = UIBezierPath(rect: CGRect(x: 0, y: 0, width: PIXEL_SIZE, height: PIXEL_SIZE))
        self.path = rect.cgPath
        self.isUserInteractionEnabled = true
        self.isAntialiased = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Point{
    
    var x : Int = 0
    var y : Int = 0
    var color : UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    init(x:Int,y:Int,color:UIColor) {
        self.x = x
        self.y = y
        self.color = color
    }
    
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

let RAWPIXEL_CONVERSION_ERR_CODE = 2619

// Helper class for making colors exportable to CGImage.
struct RawPixel {
    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
    
    init(inputColor: UIColor) throws {
        guard let (r, g, b, a) = inputColor.rgb() else {
            throw NSError(domain: "RawPixel Conversion", code: RAWPIXEL_CONVERSION_ERR_CODE, userInfo: nil)
        }
        self.r = UInt8(r)
        self.g = UInt8(g)
        self.b = UInt8(b)
        self.a = UInt8(a)
    }
}
