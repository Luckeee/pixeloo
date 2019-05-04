//
//  Command.swift
//  pixeloo
//
//  Created by hata on 2019/5/4.
//  Copyright © 2019 hata. All rights reserved.
//

import Foundation
import UIKit

class Command{
    
    var PenType = PENTYPE.pencil
    var color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    var points = [Point]()
    
    
}


enum PENTYPE {
    
    case pencil
    case eraser
    
    case clear
}


