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
    
    var Tools = ["pencil","eraser","back", "forward" , "ico_save"]
    var selectionview : UIView!
    
    var btns = [UIButton]()
    
    let cell = CGSize(width: 40, height: 40)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.9620263029, green: 0.9620263029, blue: 0.9620263029, alpha: 0.8989726027)
        
        AddToolBtns()
        AddSelectionView()
        
        SetViewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func AddToolBtns(){
        
        var i = 0

        let head :CGFloat = 10
        let specing :CGFloat = 10
        let x = (frame.width - cell.width) / 2
        
        for toolname in Tools {
//            CreateButton(toolname)
            
            let frame = CGRect(x: x, y: CGFloat(i) * (cell.height + specing) + head, width: cell.width, height: cell.height)
            let btn = UIButton(frame: frame)
            
            btn.titleLabel?.text = ""
            btn.isSelected = false
            
            btn.setBackgroundImage(UIImage(named: toolname), for: .normal)
            btn.tag = i
            
            btn.addTarget(self, action:#selector(OnBtnClicked(sender:)), for: .touchUpInside)
            
            btns.append(btn)
            addSubview(btn)
            i = i + 1
        }
        
        
    }
    
    @objc func OnBtnClicked(sender:UIButton?) {
        
        let str = Tools[sender?.tag ?? 0]

        if str == "pencil" {
            pen_type = PENTYPE.pencil
            selectionview.center = sender?.center ?? CGPoint(x: 0, y: 0)
        }
        
        if str == "eraser" {
            pen_type = PENTYPE.eraser
            selectionview.center = sender?.center ?? CGPoint(x: 0, y: 0)
        }

        if str == "back" {
            canvas.back()
        }
        
        if str == "forward" {
            canvas.forward()
        }
        
        if str == "ico_save" {
            canvas.save()
        }
    }
    
    func SetViewsLayout() {
        // shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        
        //
        layer.cornerRadius = 10
        layer.masksToBounds = false
        
    }
    
    func AddSelectionView() {
        
        let s_frame = CGRect(x: 0, y: 0, width: cell.width + 5, height: cell.height + 5)
        
        selectionview = UIView(frame:s_frame)
        
        selectionview.layer.cornerRadius = 5
        selectionview.layer.masksToBounds = false
        
        selectionview.layer.borderWidth = 2
        selectionview.layer.borderColor = UIColor.blue.withAlphaComponent(0.1).cgColor
        selectionview.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        
        self.addSubview(selectionview)
        selectionview.center = btns[0].center
    }
    
}


