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
    var collectionview : UICollectionView!
    
    var colorpicker : UIButton!
    
    var currColorView : UIView!
    
    var trashCollection: UICollectionView!
    var trashImage: UIImageView!
    
    // data
    var palette_color = UIColor.black
    
    var colors = [UIColor]()
    
    let Identifier = "CollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.9299849302, green: 0.9299849302, blue: 0.9299849302, alpha: 1)
        
        AddTrashView()
        AddColorPicker()
        AddColorCollectionView()
        AddCurrColorView()
        
        SetViewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func AddTrashView() {
        let layout = UICollectionViewFlowLayout()
        let c_frame = CGRect(x: 0, y: frame.height - 50, width: frame.width, height: 50)
        trashCollection = UICollectionView(frame: c_frame,collectionViewLayout: layout)
        trashCollection.backgroundColor = UIColor.clear
        
        trashCollection.dropDelegate = self
        
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
        
        collectionview = UICollectionView(frame: c_frame,collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.dragDelegate = self
        collectionview.dropDelegate = self
        collectionview.backgroundColor = #colorLiteral(red: 0.9299849302, green: 0.9299849302, blue: 0.9299849302, alpha: 1)
        collectionview.dragInteractionEnabled = true
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Identifier)

        InitColor(cols: nil)
        self.addSubview(collectionview)
        
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
        colors.append(color)
        collectionview.insertItems(at: [IndexPath(row: colors.count - 1, section: 0)])
    }
    
    func indexForIdentifier(identifier: UIColor)->Int?{
        return colors.firstIndex(of: identifier)
    }
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                
                self.colors.remove(at: sourceIndexPath.row)
                self.colors.insert(item.dragItem.localObject as! UIColor, at: dIndexPath.row)
                
                collectionView.moveItem(at: sourceIndexPath, to: dIndexPath)
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    
    func removeItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        collectionView.performBatchUpdates({
            
            for item in coordinator.items
            {
                guard let identifier = item.dragItem.localObject as? UIColor else {
                    return
                }
                
                if let index = indexForIdentifier(identifier: identifier){
                    let indexPath = IndexPath(row: index, section: destinationIndexPath.section)
                    colors.remove(at: index)
                    collectionview.deleteItems(at: [indexPath])
                }
            }
        })
    }
}

protocol ColorsChangesDelegate {
    func InitColor(cols: [UIColor]?)
}

extension PaletteView: ColorsChangesDelegate{
    func InitColor(cols: [UIColor]?){
        
        if cols == nil {
            colors.removeAll()
            let clorss = [0x9D9D9D,0xFFFFFF,0xBE2633,0xE06F8B,0x493C2B,0xA46422,0xEB8931,0xF7E26B,0x2F484E,0x44891A,0xA3CE27,0x1B2632,0x005784,0x31A2F2,0xB2DCEF]
            for str in clorss {
                colors.append(UIColor(hex: str))
            }
        }else{
            colors = cols!
        }
        
        if collectionview != nil {
            collectionview.reloadData()
        }
        if colors.count > 0 {
            palette_color = colors[0]
        }
        if currColorView != nil {
            currColorView.backgroundColor = palette_color
        }
    }
}

extension PaletteView: UICollectionViewDelegate {
    
    // cell  点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SelectColor(color: colors[indexPath.row])
    }
    
}

extension PaletteView: UICollectionViewDataSource{
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
}

extension PaletteView: UICollectionViewDragDelegate{
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item = self.colors[indexPath.row]
        let itemProvider = NSItemProvider(object: NSString(string: String(indexPath.row)))
        let dragitem = UIDragItem(itemProvider: itemProvider)
        dragitem.localObject = item
        
        return [dragitem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem]
    {
        let item = self.colors[indexPath.row]
        let itemProvider = NSItemProvider(object: NSString(string: String(indexPath.row)))
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension PaletteView: UICollectionViewDropDelegate{
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView === self{
            return collectionView.hasActiveDrag ?
                UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath) :
                UICollectionViewDropProposal(operation: .forbidden)
        }
        else
        {
            if collectionView.hasActiveDrag{
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            
            trashImage.alpha = 0.4
            return  UICollectionViewDropProposal(operation: .move, intent: .unspecified)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        if coordinator.proposal.operation == .move{
            if coordinator.proposal.intent == .insertAtDestinationIndexPath{
                self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            }
            else{
                self.removeItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
        trashImage.alpha = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        trashImage.alpha = 0
    }
}
