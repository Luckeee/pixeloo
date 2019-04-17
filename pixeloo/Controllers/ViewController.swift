//
//  ViewController.swift
//  pixeloo
//
//  Created by hata on 2019/4/14.
//  Copyright © 2019 hata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print("view loaded")
    }

    @IBAction func OnAddTouchUpInside(_ sender: UIButton) {
        print("Button Touch Up inside")
        
        let canvasBoard = UIStoryboard(name:"Canvas",bundle:nil)
        let canvasController = canvasBoard.instantiateViewController(withIdentifier: "CanvasController")
        self.present(canvasController, animated: true, completion: nil)

    }

}

