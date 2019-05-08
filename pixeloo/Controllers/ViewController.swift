//
//  ViewController.swift
//  pixeloo
//
//  Created by hata on 2019/4/14.
//  Copyright © 2019 hata. All rights reserved.
//

import UIKit
import Social


class ViewController: UIViewController{
    
    var canvaDatas = [CanvasData]()
    
    var isColorTextFieldHidden: Bool = true
    
    var headerview : UIView!
    var collection : UICollectionView!
    var addBtn : UIButton!
    
    var canvasController : CanvasController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.backgroundColor = UIColor.darkGray
        
        AddHeaderView()
        AddCollectionView()
        GetAppHistory()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if collection != nil {
            collection.reloadData()
        }
        
    }
    
    func AddHeaderView() {
        let h_frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: 40)
        headerview = UIView(frame: h_frame)
        
        let layer_line = CALayer()
        layer_line.frame = CGRect(x: 0, y: headerview.height-1, width: headerview.width, height: 1)
        layer_line.backgroundColor = UIColor.gray.cgColor
        
        headerview.layer.addSublayer(layer_line)
        
        let b_frame = CGRect(x: view.bounds.width - 60, y: 0, width: 40, height: 40)
        addBtn = UIButton(frame: b_frame)
        addBtn.setImage(UIImage(named: "ico_add"), for: .normal)

        addBtn.addTarget(self, action:#selector(OnAddBtnClicked(sender:)), for: .touchUpInside)
        headerview.addSubview(addBtn)
        
        view.addSubview(headerview)
    }
    
    func AddCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200,height: 200)
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 30)
        
        let c_frame = CGRect(x: 50, y: 60, width: view.bounds.width - 100 , height: view.bounds.height - 60)
        
        collection = UICollectionView(frame: c_frame,collectionViewLayout: layout)
        collection.backgroundColor = UIColor.darkGray
        
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceVertical = true

        // 注册cell
        collection.register(MainCollectionCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        
        view.addSubview(collection)
    }
    
    @objc func OnAddBtnClicked(sender:UIButton?) {
        ShowCanvas(data: nil)
    }
    
    func ShowCanvas(data :CanvasData?) {
        
        if canvasController == nil {
            let canvasBoard = UIStoryboard(name:"Canvas",bundle:nil)
            
            canvasController = canvasBoard.instantiateViewController(withIdentifier: "CanvasController") as? CanvasController
            canvasController.adddata_delegate = self
        }
        
        if data == nil {
            canvasController.canvadata = CanvasData()
        }else{
            canvasController.canvadata = data
        }
        
        self.present(canvasController, animated: true, completion: nil)
    }
    
    func GetAppHistory() {
        DataManager.GetAllHistorys(callback: self.HistorysLoaded(_:))
    }
    
    func HistorysLoaded(_ to : [CanvasData]) {
        canvaDatas = to
        collection.reloadData()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        collection.frame.size = CGSize(width: size.width - 100, height: size.height - 60)
        headerview.frame.size = CGSize(width: size.width, height: 40)
        addBtn.frame.origin = CGPoint(x: size.width - 60, y: 0)
    }
    
    func OnCanvasClick(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let alertController = UIAlertController(title: "操作", message: "", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "删除", style: .destructive, handler: {
            action in
            DataManager.delete(data: self.canvaDatas[indexPath.row])
            self.canvaDatas.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        })
        let editAction = UIAlertAction(title: "编辑", style: .default, handler: {
            action in
            self.ShowCanvas(data :self.canvaDatas[indexPath.row])
        })
        
        let shareAction = UIAlertAction(title: "分享", style: .default, handler: {
            action in
            guard let img = UIImage(data: self.canvaDatas[indexPath.row].imagedata! as Data) else { return }
            self.shareImage(images:[img])
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(shareAction)
        alertController.addAction(editAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func shareImage(images:[UIImage]){
        
        let activityVC = UIActivityViewController(activityItems: images as [Any],
                                                  applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList,
                                            UIActivity.ActivityType.assignToContact,
                                            UIActivity.ActivityType.openInIBooks,
                                            UIActivity.ActivityType.copyToPasteboard,
                                            UIActivity.ActivityType.openInIBooks]
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true)
    }

}

extension ViewController:UICollectionViewDelegate {
    
    // cell  点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        OnCanvasClick(collectionView,didSelectItemAt: indexPath)
    }
}

extension ViewController: UICollectionViewDataSource{
    // 返回 cell 的数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return canvaDatas.count
    }
    
    // 返回每个cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell :MainCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionCell
        
        cell.accessibilityLabel = String(format:"%ditem",indexPath.row)
        cell.SetBackgroundImage(image: UIImage(data: canvaDatas[indexPath.row].imagedata! as Data)!)
        return cell
        
    }
}

class MainCollectionCell : UICollectionViewCell{
    
    var bgimage :UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGray
        
        bgimage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        addSubview(bgimage)
    }
    
    func SetBackgroundImage(image:UIImage) {
        bgimage.image = image
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol AddCanvasData {
    func AddCanvasData(data: CanvasData)
}

extension ViewController : AddCanvasData{
    func AddCanvasData(data: CanvasData){
        if !canvaDatas.contains(data) {
            canvaDatas.append(data)
        }
    }
}
