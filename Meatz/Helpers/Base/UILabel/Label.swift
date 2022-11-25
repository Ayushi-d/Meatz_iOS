//
//  BaseLabel.swift
//
//  Created by Mahmoud Khaled on 6/10/20.
//  Copyright © 2020 Mahmoud Khaled. All rights reserved.
//

import UIKit

/// Plain Label
@IBDesignable
open class BaseLabel: UILabel, ViewFontProtocol {
    
    public var fontType: FontsType {
        get { return .regular }
        set {}
    }

    @IBInspectable var alignmentEnabled: Bool = true {
        didSet {
            setAlignment()
        }
    }
    @IBInspectable public var fontSize: CGFloat = 16.0 {
        didSet{
            updateFontProperities()
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        updateFontProperities()
    }
    
    func setAlignment() {
        guard alignmentEnabled else {
             textAlignment = .center
             return }
         textAlignment = MOLHLanguage.isArabic() ? .right : .left
     }
}

/// Bold Label
open class BoldLabel: BaseLabel {
    
    override public var fontType: FontsType {
        get{ return .bold }
        set{}
    }
}

// SemiBold
open class SemiBoldLabel: BaseLabel {
    override public var fontType: FontsType {
        get{ return .semiBold }
        set{}
    }
}

// Light
open class LighLabel: BaseLabel {
    override public var fontType: FontsType {
        get{ return .light }
        set{}
    }
}
//Medium
open class MediumLabel: BaseLabel {
    override public var fontType: FontsType {
        get{ return .medium }
        set{}
    }
}
