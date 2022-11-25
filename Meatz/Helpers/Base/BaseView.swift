//
//  UIView + Extension.swift
//  Asnan Tower
//
//  Created by Mohamed Zead on 12/31/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class BaseView: UIView {
    
    
    @IBInspectable var isShadow: Bool = true {
        didSet {
            self.updateProperties()
        }
    }
    
    @IBInspectable var isCircle: Bool = false {
        didSet {
            self.cornerRadius = self.frame.height/2
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.updateProperties()
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.updateProperties()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            self.updateProperties()
        }
    }
    
    
    /// The shadow color of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowColor: UIColor = UIColor.lightText {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow offset of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowBlure: CGFloat = 3 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow opacity of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOpacity: Float = 4 {
        didSet {
            self.updateProperties()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateProperties()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateProperties()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateProperties()
    }
    
    /**
     Updates all layer properties according to the public properties of the `ShadowView`.
     */
    fileprivate func updateProperties() {
        
        
        if isShadow{
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOpacity = shadowOpacity
            layer.shadowOffset = shadowOffset
            layer.shadowRadius = shadowBlure
        }
        layer.cornerRadius  = cornerRadius
        layer.borderColor = borderColor?.cgColor ?? self.backgroundColor?.cgColor ?? UIColor.white.cgColor
        layer.borderWidth = borderWidth
    }
    
}
