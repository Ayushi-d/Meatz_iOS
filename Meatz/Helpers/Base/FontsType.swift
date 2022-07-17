//
//  FontsType.swift
//
//  Created by Khaled kamal on 10/28/20.
//  Copyright © 2020 Khaled kamal. All rights reserved.
//

import UIKit

public enum FontsType {
    case light
    case regular
    case bold
    case semiBold
    case medium
    case extraBold
    
    func getFontWithSize(_ size: CGFloat) -> UIFont? {
        if MOLHLanguage.isArabic() {
            return arFont(size)
        }
        return enFont(size)
    }

    private func arFont(_ size: CGFloat) -> UIFont? {
        switch self {
        case .bold, .medium: return R.font.almaraiBold(size: size)
        case .light : return R.font.almaraiLight(size: size)
        case .extraBold : return R.font.almaraiExtraBold(size: size)
        default: return R.font.almaraiRegular(size: size)
        }
    }

    private func enFont(_ size: CGFloat) -> UIFont? {
        switch self {
        case .semiBold: return R.font.poppinsSemiBold(size: size)
        case .bold: return R.font.poppinsBold(size: size)
        case .medium:return R.font.poppinsMedium(size: size)
        default:
            return R.font.poppinsRegular(size: size)
        }
    }
}

public protocol ViewFontProtocol {
    var fontType: FontsType { get set }
    var fontSize: CGFloat { get }
    func updateFontProperities()
}

// MARK: - UILabel

extension ViewFontProtocol where Self: UILabel {
    public func updateFontProperities() {
        font = fontType.getFontWithSize(fontSize)
    }
}

// MARK: - UIButton

extension ViewFontProtocol where Self: UIButton {
    public func updateFontProperities() {
        titleLabel?.font = fontType.getFontWithSize(fontSize)
    }
}

// MARK: - UITextField

extension ViewFontProtocol where Self: UITextField {
    public func updateFontProperities() {
        font = fontType.getFontWithSize(fontSize)
    }
}
