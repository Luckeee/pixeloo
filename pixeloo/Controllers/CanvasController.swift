//
//  File.swift
//  pixeloo
//
//  Created by hata on 2019/4/15.
//  Copyright © 2019 hata. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class CanvasController: UIViewController {
    
    var palette : PaletteView!
    var penciltool : PencilToolView!
    var canvas : CanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShowCanvas()
        ShowPalette()
        ShowPencilTool()
        
        // TODO
        //ShowMinimap()
        //ShowSetting()
    }
    
    func ShowPalette(){
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 30,height: 30)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let frame = CGRect(x: 0,y: 100,width: 90,height: 200)
        
        palette = PaletteView(frame: frame, collectionViewLayout:layout)
        
        view.addSubview(palette)
    }
    
    func ShowPencilTool(){
        
        let frame = CGRect(x: 100,y: 20,width: 150,height: 40)
        
        penciltool = PencilToolView(frame: frame)
        
        view.addSubview(penciltool)
    }
    
    func ShowCanvas() {
        
        let size = CancasSize(width: 64, height: 47)
        let frame = CGRect(x: 0,y: 0,width: SCREEN_WIDTH,height: SCREEN_HEIGHT)
        canvas = CanvasView(frame:frame, size:size)
        view.addSubview(canvas)
    }
    
    
    
}

