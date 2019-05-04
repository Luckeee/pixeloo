//
//  PaletteView.swift
//  pixeloo
//
//  Created by hata on 2019/4/16.
//  Copyright © 2019 hata. All rights reserved.
//

import Foundation
import UIKit

class PaletteView : UICollectionView , UICollectionViewDelegate, UICollectionViewDataSource  {
    
    let Identifier       = "CollectionViewCell"
    let headerIdentifier = "CollectionHeaderView"
    let footIdentifier   = "CollectionFootView"

    var colors = [UIColor]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        print("init ??")
    
        super.init(frame: frame, collectionViewLayout:layout)
        
        self.backgroundColor = UIColor.red
        
        self.delegate = self
        self.dataSource = self
        // 注册cell
        self.register(Palette_Cell.self, forCellWithReuseIdentifier: Identifier)
        
        InitColorList()
        
        self.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // cell  点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        palete_color = colors[indexPath.row]
        print(indexPath.row,palete_color)
    }
    
    // 返回 cell 的数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    // 返回每个cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        cell.accessibilityLabel = String(format:"%ditem",indexPath.row)
        return cell
    }
    
    func InitColorList(){
        for _ in 1...18 {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            colors.append(UIColor(red: red, green: green, blue: blue, alpha: 1.0))
        }
    }
}


class Palette_Cell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
