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

var palette : PaletteView!
var penciltool : PencilToolView!
var canvas : CanvasView!

class CanvasController: UIViewController {
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpScrollView()
        ShowCanvas()
        ShowPalette()
        ShowPencilTool()
        
        // TODO
        //ShowMinimap()
        //ShowSetting()
    }
    
    func SetUpScrollView(){
        
        scrollview.maximumZoomScale = 3.0
        scrollview.minimumZoomScale = 0.1
        scrollview.panGestureRecognizer.minimumNumberOfTouches = 2
        scrollview.panGestureRecognizer.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        scrollview.pinchGestureRecognizer?.allowedTouchTypes = [UITouch.TouchType.direct.rawValue as NSNumber]
        scrollview.delaysContentTouches = false
        scrollview.delegate = self
        scrollview.bounces = true
        scrollview.bouncesZoom = true
        scrollview.frame = view.bounds
        scrollview.alwaysBounceHorizontal = true
        scrollview.contentMode = .center
        scrollview.contentSize = view.bounds.size
        scrollview.translatesAutoresizingMaskIntoConstraints = false
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
        
        let frame = CGRect(x: 100, y: 20, width: 300, height: 40)
        
        penciltool = PencilToolView(frame: frame)
        
        view.addSubview(penciltool)
    }
    
    func ShowCanvas() {
        
        let size = CancasSize(width: 64, height: 64)
        let frame = CGRect(x: 0,y: 0,width: PIXEL_SIZE * size.width,height: PIXEL_SIZE * size.height)
        canvas = CanvasView(frame:frame, size:size)
        canvas.translatesAutoresizingMaskIntoConstraints = false
        scrollview.addSubview(canvas)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollview.flashScrollIndicators()
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CanvasController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}

// MARK: - UIScrollViewDelegate
extension CanvasController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvas
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = canvas.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        var desiredScale = self.traitCollection.displayScale
        let existingScale = canvas.contentScaleFactor
        
        if scale >= 2.0 {
            desiredScale *= 2.0
        }
        
        if abs(desiredScale - existingScale) > 0.000_01 {
            canvas.contentScaleFactor = desiredScale
            canvas.setNeedsDisplay()
        }
    }
    
}
