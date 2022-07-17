//
//  ZSliderSource.swift
//  servants
//
//  Created by Mac on 3/20/20.
//  Copyright © 2020 spark. All rights reserved.
//

import Foundation
import UIKit

public protocol ZSliderSource{
    var source : ZImageSourceType{get }
    var urlString : String? {get }
    var image : UIImage?{get}
}

extension ZSliderSource{
    var urlString : String?{
        return nil
    }
    public var image : UIImage?{
        return nil
    }
}




public enum ZImageSourceType{
    case url
    case image
}
