//
//  EnglishFont.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/21/21.
//

import Foundation
import UIKit

final class EnglishFont : UIFont{
    
    private var weight : EnglishFontWeight
    init(_ weight : EnglishFontWeight) {
        self.weight = weight
        super.init()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var fontName: String{
        return  weight.rawValue
    }
}

enum EnglishFontWeight : String{
    case regular = "Poppins-Regular"
    case medium = "Poppins-Medium"
    case semiBold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
}
