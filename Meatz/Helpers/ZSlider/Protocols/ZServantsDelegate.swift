//
//  ZSliderDelegate.swift
//  servants
//
//  Created by Mac on 3/20/20.
//  Copyright © 2020 spark. All rights reserved.
//

import Foundation
import UIKit


public protocol ZSliderDelegate : AnyObject {
   //indexing from 0
    func didDisplayItem(_ slider : ZSliderImageSliderView,At index:Int)
    
    func didSelectItem(_ slider : ZSliderImageSliderView,At index : Int)
    
    
    
}
