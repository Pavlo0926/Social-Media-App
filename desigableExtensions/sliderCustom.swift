//
//  sliderCustom.swift
//  HotShot Firing System
//
//  Created by Apple on 02/07/2019.
//  Copyright © 2019 AppicSolution. All rights reserved.
//

import Foundation
import UIKit
class CustomSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 8
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
}
