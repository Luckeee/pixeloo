//
//  PaletteView.swift
//  pixeloo
//
//  Created by hata on 2019/4/16.
//  Copyright © 2019 hata. All rights reserved.
//

import Foundation
import UIKit

class ColorCollectionView : UICollectionView  {
    
    let Identifier       = "CollectionViewCell"
    let headerIdentifier = "CollectionHeaderView"
    let footIdentifier   = "CollectionFootView"

    var colors = [UIColor]()
    
    var paletteview :PaletteView!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    
        super.init(frame: frame, collectionViewLayout:layout)
        
        self.backgroundColor = #colorLiteral(red: 0.9299849302, green: 0.9299849302, blue: 0.9299849302, alpha: 1)
        
        self.delegate = self
        self.dataSource = self
        self.dragDelegate = self
        self.dropDelegate = self

        self.dragInteractionEnabled = true
        
        // 注册cell
        self.register(ColorCollectionCell.self, forCellWithReuseIdentifier: Identifier)
        
        InitColorList()
        
        self.reloadData()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        paletteview.trashCollection.dropDelegate = self
    }
    
    func InitColorList(){
        
        let clorss = [0x9D9D9D,0xFFFFFF,0xBE2633,0xE06F8B,0x493C2B,0xA46422,0xEB8931,0xF7E26B,0x2F484E,0x44891A,0xA3CE27,0x1B2632,0x005784,0x31A2F2,0xB2DCEF,]
        
        for str in clorss {
            colors.append(UIColor(hex: str))
        }
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
                    let indexPath = IndexPath(row: index, section: 0)
                    colors.remove(at: index)
                    self.deleteItems(at: [indexPath])
                }
            }
        })
    }

    func AddColor(color:UIColor){
        palete_color = color
        colors.append(color)
        self.insertItems(at: [IndexPath(row: colors.count - 1, section: 0)])
    }
    
}

extension ColorCollectionView:UICollectionViewDelegate {
    
    // cell  点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        palete_color = colors[indexPath.row]
        paletteview.SelectColor(color: palete_color)
    }
    
}

extension ColorCollectionView: UICollectionViewDataSource{
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

extension ColorCollectionView: UICollectionViewDragDelegate{

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

extension ColorCollectionView: UICollectionViewDropDelegate{
    
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
            
            paletteview.trashImage.alpha = 0.4
            return  UICollectionViewDropProposal(operation: .move, intent: .unspecified)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("collectionView")
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
        paletteview.trashImage.alpha = 1
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        paletteview.trashImage.alpha = 0
    }
}


class ColorCollectionCell: UICollectionViewCell {
    
    var select_view: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

