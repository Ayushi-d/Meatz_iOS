

import UIKit

@IBDesignable
class BaseButton: UIButton, ViewFontProtocol {
    // MARK: - Fonts
    
    var fontType: FontsType {
        get { return .regular }
        set {}
    }
    
    @IBInspectable var fontSize: CGFloat = 16.0 {
        didSet { updateFontPropreities() }
    }
    
    @IBInspectable var alignmentEnabled: Bool = true {
        didSet {
            setAlignment()
        }
    }
    
    private func updateFontPropreities() {
        self.titleLabel?.font = fontType.getFontWithSize(fontSize)
    }
    
    // MARK: - Shape
    
    @IBInspectable var isCircle: Bool = false {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable var borderColor: UIColor? = nil {
        didSet {
            guard let _borderColor = borderColor else {
                return
            }
            updateProperties()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            updateProperties()
        }
    }
    
    // MARK: - Shadow
    
    /// Shadow View
    @IBInspectable var isShadow: Bool = false {
        didSet {
            self.updateProperties()
        }
    }
    
    /// The shadow color of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowColor: UIColor = UIColor.lightGray {
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
    @IBInspectable var shadowRadius: CGFloat = 2 {
        didSet {
            self.updateProperties()
        }
    }
    
    /// The shadow opacity of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOpacity: Float = 3 {
        didSet {
            self.updateProperties()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateUI()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
        //self.imageView?.image?.imageFlippedForRightToLeftLayoutDirection()
        if MOLHLanguage.isArabic() {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    private func updateUI() {
        updateFontPropreities()
        updateProperties()
    }
    
    private func updateProperties() {
        /// Shape
        
        if isCircle {
            self.layer.cornerRadius = self.frame.height / 2
        } else {
            layer.cornerRadius = cornerRadius
        }
        
        layer.borderColor = borderColor?.cgColor ?? backgroundColor?.cgColor
        layer.borderWidth = borderWidth
        layer.masksToBounds = false
        layer.shouldRasterize = true
        
        if isShadow {
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOpacity = shadowOpacity
            layer.shadowOffset = shadowOffset
            layer.shadowRadius = shadowRadius
        }
        layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    func setAlignment() {
        guard alignmentEnabled else {
            titleLabel?.textAlignment = .center
            return
        }
        titleLabel?.textAlignment = MOLHLanguage.isArabic() ? .right : .left
    }
}

class BoldButton: BaseButton {
    override var fontType: FontsType {
        get {
            return .bold
        } set {}
    }
}

class SemiBoldButton: BaseButton {
    override var fontType: FontsType {
        get {
            return .semiBold
        } set {}
    }
}

class MediumButton : BaseButton{
    override var fontType: FontsType {
        get {
            return .medium
        } set {}
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
