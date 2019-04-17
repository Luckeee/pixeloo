//
//  CanvasVIew.swift
//  pixeloo
//
//  Created by hata on 2019/4/16.
//  Copyright © 2019 hata. All rights reserved.
//

import Foundation
import SpriteKit

class CanvasView : SKView {
    
    var size : CancasSize!
    var sprits = [[SKSpriteNode]]()
    var canvasScene: SKScene!
    
    init(frame: CGRect, size:CancasSize) {
        super.init(frame: frame)
        self.size = size
//        canvasScene = SKScene(size: CGSize(width: 1024 ,height: 1024))
//        presentScene(canvasScene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        print("didMoveToSuperview ")
        
        //  创建 size 个sksprite
        for h in 0..<size.height {
            
            var tmp = [SKSpriteNode]()
            for w in 0..<size.width {
                let node = SKSpriteNode()
                
                if h == 63 || w == 0 {
                    node.color = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                }else {
                    node.color = amcolor()
                }
                
                node.name = String.init(format: "%d_%d", w,h)
                node.position = CGPoint(x: (Double(w) + 0.5) * 16, y: (Double(h) + 0.5) * 16)
                node.size = CGSize(width: 16, height: 16)
                tmp.append(node)
                
                scene?.addChild(node)
            }
            sprits.append(tmp)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches)
    }
    
    func amcolor() -> UIColor {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

public struct CancasSize {
    var width : Int = 0
    var height : Int = 0
}
