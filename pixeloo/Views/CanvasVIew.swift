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
    var canvasScene: SKScene!
    var sprite :SKSpriteNode!
    var pixelArray = [[Pixel]]()
    
    init(frame: CGRect, size:CancasSize) {
        super.init(frame: frame)
        self.size = size
        canvasScene = SKScene( size: CGSize(width: SCREEN_WIDTH ,height: SCREEN_HEIGHT))
        presentScene(canvasScene)
        
        sprite = SKSpriteNode()
        let sprite_w = CGFloat(PIXEL_SIZE * size.width)
        let sprite_h = CGFloat(PIXEL_SIZE * size.height)
        sprite.position = CGPoint(x: (SCREEN_WIDTH -  sprite_w) / 2, y: (SCREEN_HEIGHT -  sprite_h) / 2)
        sprite.size = CGSize(width: sprite_w, height: sprite_h)
        
        canvasScene.addChild(sprite)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        print("didMoveToSuperview ")
        
        //  创建 size 个sksprite
        for h in 0..<size.height {
            
            var tmp = [Pixel]()
            for w in 0..<size.width {
                let pixel = Pixel()

                pixel.name = String.init(format: "%d_%d", w,h)
                pixel.position = CGPoint(x: w * 16, y: h * 16)
                tmp.append(pixel)
                
                sprite.addChild(pixel)
            }
            pixelArray.append(tmp)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            handleTouch(touch: touch, type : 0)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            handleTouch(touch: touch , type : 1)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        tmp_pos = nil
    }
 
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tmp_pos = nil
    }
    
    var tmp_pos : CGPoint!
    
    func handleTouch(touch : UITouch, type : Int) {
        
        var poses : [Point]
        
        if type != 0 {
            poses = caculateoo(pointx: tmp_pos,pointy: touch.location(in: sprite))
        }else{
            let pos = Point(cgpoint: touch.location(in: sprite))
            poses = [Point]()
            poses.append(pos)
        }
        
        tmp_pos = touch.location(in: sprite)
        
        for pos in poses {
            if pos.y > pixelArray.count ||  pos.y < 0 {
                return
            }
            
            if  pos.x < 0 ||  pos.y > pixelArray[0].count {
                return
            }
            
            pixelArray[pos.y][pos.x].fillColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
    
    func caculateoo(pointx : CGPoint, pointy : CGPoint ) -> [Point]  {
        var poss = [Point]()
        
        let p_a = Point(cgpoint: pointx)
        let p_b = Point(cgpoint: pointy)
        poss.append(p_a)
        poss.append(p_b)
        
        let dis = p_a.distance(q: p_b)
        if dis >= 2 {
            let tmp = CGPoint(x: (pointx.x - pointy.x) / CGFloat(dis) ,y: (pointx.y - pointy.y) / CGFloat(dis))
            
            for idx in 1..<dis {
                let tmp_pos = CGPoint(x: pointy.x + tmp.x * CGFloat(idx),y: pointy.y + tmp.y * CGFloat(idx))
                let p_t = Point(cgpoint: tmp_pos)
                poss.append(p_t)
            }
        }
        
        return poss
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
