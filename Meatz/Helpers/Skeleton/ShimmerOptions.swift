//
//  SwimmerOptions.swift
//  ShimmerView
//
//  Created by Drouin on 26/07/2019.
//  Copyright © 2019 VersusMind. All rights reserved.
//

import UIKit

public class ShimmerOptions {
    public static let instance = ShimmerOptions()
    
    enum Direction {
        case topBottom
        case bottomTop
        case leftRight
        case rightLeft
    }
    
    enum AnimationType {
        case classic
        case fade
    }
    
    // Animation option
    var animationDuration: CGFloat = 1.0
    var animationDelay: CGFloat = 0.3
    var animationAutoReserse = true
    var animationDirection: Direction = .leftRight
    var animationType: AnimationType = .classic
    
    // Shimmer background option
    var gradientColor = #colorLiteral(red: 0.8827802415, green: 0.8827802415, blue: 0.8827802415, alpha: 1)
    var borderWidth: CGFloat = 0.0
    var borderColor = UIColor.lightGray
    var backgroundColor = #colorLiteral(red: 0.9294837117, green: 0.9331728816, blue: 0.9462363124, alpha: 1)
    
    
    
    private init() { }
}


