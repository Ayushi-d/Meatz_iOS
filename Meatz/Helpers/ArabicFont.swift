//
//  ArabicFont.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/21/21.
//

import Foundation
import UIKit

final class ArabicFont : UIFont{
    private var weight : ArabicFontWeight
    init(weight:ArabicFontWeight) {
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

enum ArabicFontWeight : String{
    case regular = "Almarai-Regular"
    case light = "Almarai-Light"
    case bold = "Almarai-Bold"
    case extraBold = "Almarai-ExtraBold"
}
