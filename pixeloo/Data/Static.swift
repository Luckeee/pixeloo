//
//  Static.swift
//  pixeloo
//
//  Created by hata on 2019/4/30.
//  Copyright © 2019 hata. All rights reserved.
//

import Foundation
import UIKit

// every Pixel
let PIXEL_SIZE = 16

// FIXME: Make this dynamic
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height - 20
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
// Maximum amount of pixels shown on screen when zooming in.
let MAX_ZOOM: CGFloat = 2
let MIN_ZOOM: CGFloat = 0.4

// Tolerance for checking equality of UIColors.
let COLOR_EQUALITY_TOLERANCE: CGFloat = 0.001

let ANIMATION_DURATION: TimeInterval = 0.4

/// Drawing toolbar icon width.
let ICON_WIDTH: CGFloat = 40.0
/// Drawing toolbar icon height.
let ICON_HEIGHT: CGFloat = ICON_WIDTH

/// Pipette tool offset so that the pipette tool
/// is not located directly under the finger of the user
/// and thus cannot be seen.
let PIPETTE_TOOL_OFFSET: CGFloat = 10.0


// 全局变量

var palete_color : UIColor = UIColor.black

var pen_type = PENTYPE.pencil
