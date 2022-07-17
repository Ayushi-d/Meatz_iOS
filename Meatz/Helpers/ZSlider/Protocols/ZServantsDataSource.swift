//
//  ZSliderDataSource.swift
//  servants
//
//  Created by Mac on 3/20/20.
//  Copyright © 2020 spark. All rights reserved.
//

import Foundation
import UIKit

public protocol ZSliderDataSource : AnyObject{
    func imagesFor(_ slider : ZSliderImageSliderView )->[ZSliderSource]
}



