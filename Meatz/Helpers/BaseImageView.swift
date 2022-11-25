//
//  BaseImageView.swift
//  Blue Nile
//
//  Created by Mahmoud Khaled on 6/12/20.
//  Copyright © 2020 Mahmoud Khaled. All rights reserved.
//

import UIKit

@IBDesignable
class BaseImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true

        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

