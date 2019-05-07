//
//  PaletteView.swift
//  pixeloo
//
//  Created by hata on 2019/5/6.
//  Copyright © 2019 hata. All rights reserved.
//

import Foundation
import UIKit

class PaletteView: UIView{
   
    // view
    var collecrionview : ColorCollectionView!
    
    var colorpicker : UIButton!
    
    var currColorView : UIView!
    
    var trashCollection: UICollectionView!
    var trashImage: UIImageView!
    
    // data
    var palette_color = UIColor.black
    
    override func didMoveToWindow() {
        
        self.backgroundColor = #colorLiteral(red: 0.9299849302, green: 0.9299849302, blue: 0.9299849302, alpha: 1)
        
        AddTrashView()
        AddColorPicker()
        AddColorCollectionView()
        AddCurrColorView()
        
        SetViewsLayout()
        
    }
    
    func AddTrashView() {
        let layout = UICollectionViewFlowLayout()
        let c_frame = CGRect(x: 0, y: frame.height - 50, width: frame.width, height: 50)
        trashCollection = UICollectionView(frame: c_frame,collectionViewLayout: layout)
        trashCollection.backgroundColor = UIColor.clear
        
        let i_frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        trashImage = UIImageView(frame: i_frame)
        trashImage.image = UIImage(named: "trashImage")
        trashImage.alpha = 0
        trashCollection.addSubview(trashImage)
        
        self.addSubview(trashCollection)
    }
    
    func AddCurrColorView() {
        
        let c_frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        currColorView = UIView(frame: c_frame)

        self.addSubview(currColorView)
        
        currColorView.backgroundColor = palette_color
        
        currColorView.layer.cornerRadius = 5
        currColorView.layer.shadowRadius = 1
        currColorView.layer.shadowOpacity = 0.8
        currColorView.layer.shadowOffset = CGSize(width: 0, height: 0)
        currColorView.layer.shadowColor = UIColor.lightGray.cgColor
        currColorView.layer.masksToBounds = false
    }
    
    func AddColorCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60,height: 30)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.footerReferenceSize = CGSize(width: 92, height: 50)
        
        let c_frame = CGRect(x: 0, y: 50, width: frame.width, height: frame.height - 100)
        collecrionview = ColorCollectionView(frame: c_frame,collectionViewLayout: layout)
        collecrionview.paletteview = self
        
        self.addSubview(collecrionview)
        
        // layer
        let layer1 = CALayer()
        layer1.frame = CGRect(x: 0, y: 49, width: frame.width, height: 1)
        layer1.backgroundColor = UIColor.lightGray.cgColor
        
        let layer2 = CALayer()
        layer2.frame = CGRect(x: 0, y: frame.height - 50, width: frame.width, height: 1)
        layer2.backgroundColor = UIColor.lightGray.cgColor
        
        layer.addSublayer(layer1)
        layer.addSublayer(layer2)
    }
    
    func AddColorPicker() {

        // btn
        let c_frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        let color_btn = UIButton(frame: c_frame)
        color_btn.setImage(UIImage(named: "palette"), for: .normal)
        color_btn.addTarget(self, action:#selector(touchSelect(sender:)), for: .touchUpInside)
        
        trashCollection.addSubview(color_btn)
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
    
    @objc func touchSelect (sender: UITapGestureRecognizer){
        let alert = UIAlertController(style: .alert)
        alert.addColorPicker(color: palete_color) { color in self.AddColor(color: color) }
        alert.addAction(title: "Cancel", style: .cancel)
        alert.show()
    }
    
    func SelectColor(color:UIColor) {
        palete_color = color
        currColorView.backgroundColor = palete_color
    }
    
    func AddColor(color:UIColor){
        currColorView.backgroundColor = color
        palete_color = color
        collecrionview.AddColor(color: color)
    }
}
