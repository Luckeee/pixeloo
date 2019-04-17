//
//  PencilToolView.swift
//  pixeloo
//
//  Created by hata on 2019/4/16.
//  Copyright © 2019 hata. All rights reserved.
//

import Foundation
import UIKit

class PencilToolView: UIView {
    
    var Tools = ["select","pencil","eraser"]
    
    public var currentTool = "pencil"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.6750302911, green: 0.2017385662, blue: 0.2722268105, alpha: 1)
        AddToolBtns()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func AddToolBtns(){
        
        var i = 0
        
        for toolname in Tools {
//            CreateButton(toolname)
            
            let frame = CGRect(x: i * 40 + 5, y: 5, width: 35, height: 35)
            let btn = UIButton(frame: frame)
            
            btn.titleLabel?.text = ""
            btn.isSelected = false
            
            btn.setBackgroundImage(UIImage(named: toolname), for: .normal)
            btn.tag = i
            
            btn.addTarget(self, action:#selector(OnBtnClicked(sender:)), for: .touchUpInside)
            
            addSubview(btn)
            i = i + 1
        }
    }
    
    @objc func OnBtnClicked(sender:UIButton?) {
        
        currentTool = Tools[sender?.tag ?? 0]
        
        print("currentTool" , currentTool)
    }

    
}


