//
//  PaletteView.swift
//  pixeloo
//
//  Created by hata on 2019/4/16.
//  Copyright © 2019 hata. All rights reserved.
//

import Foundation
import UIKit

class PaletteView : UICollectionView  {
    
    let Identifier       = "CollectionViewCell"
    let headerIdentifier = "CollectionHeaderView"
    let footIdentifier   = "CollectionFootView"

    var colors = [UIColor]()
    var controller : CanvasController!
    
    public var trashCollection: UICollectionView!
    public var trashImage: UIImageView!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    
        super.init(frame: frame, collectionViewLayout:layout)
        
        self.backgroundColor = UIColor.lightGray
        
        self.delegate = self
        self.dataSource = self
        self.dragDelegate = self
        self.dropDelegate = self

        self.dragInteractionEnabled = true
        // 注册cell
        self.register(Palette_Cell.self, forCellWithReuseIdentifier: Identifier)
        self.register(CollectionFootView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footIdentifier)
        
        InitColorList()
        
        self.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        trashCollection.dropDelegate = self
    }
    
    func InitColorList(){
        for _ in 1...18 {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            colors.append(UIColor(red: red, green: green, blue: blue, alpha: 1.0))
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
    
}

extension PaletteView:UICollectionViewDelegate {
    
    // cell  点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        palete_color = colors[indexPath.row]
        print(indexPath.row,palete_color)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        let footView : CollectionFootView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footIdentifier, for: indexPath) as! CollectionFootView
        footView.controller = self.controller
        return footView
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
        trashImage.alpha = 1
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        trashImage.alpha = 0
    }
}


class Palette_Cell: UICollectionViewCell {
    
    var select_view: UIImageView!
    
    override var isSelected: Bool{
        didSet{
            select_view.isHidden = !isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        select_view = UIImageView()
        select_view.frame.size = frame.size
        select_view.frame.origin = CGPoint(x: 0, y: 0)
        select_view.image = UIImage(named:"selected_icon")
        self.addSubview(select_view)
        select_view.isHidden = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CollectionFootView: UICollectionReusableView {
    
    var color_btn : UIButton!
    var controller : CanvasController!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        let c_frame = CGRect(x: 10, y: 10, width: 70, height: 20)
        
        color_btn = UIButton(frame: c_frame)
        color_btn.backgroundColor = UIColor.green
        
        self.addSubview(color_btn)
        
        color_btn.addTarget(self, action:#selector(touchSelect(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func touchSelect (sender: UITapGestureRecognizer){
        let alert = UIAlertController(style: .alert)
        alert.addColorPicker(color: UIColor(hex: 0xFF2DC6)) { color in self.color_btn.backgroundColor = color }
        alert.addAction(title: "Cancel", style: .cancel)
        alert.show()
    }
}

