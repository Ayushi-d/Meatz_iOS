//
//  BaseTextField.swift
//  Asnan Tower
//
//  Created by Mohamed Zead on 12/31/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class BaseTextField: UITextField {
    public var observe: (String?) -> () = { _ in }
    @IBInspectable var alignmentEnabled: Bool = true {
        didSet {
            setAlignment()
        }
    }

    @IBInspectable var placeHolderTextColor : UIColor = UIColor.placeholderText{
        didSet{
            setUpPlaceHolderColor()
        }
    }
    
    @IBInspectable var textColorr : UIColor = R.color.meatzBlack()!{
        didSet{
            self.textColor = textColorr
        }
    }
    
    @IBInspectable var isBold: Bool = false {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable var padding: CGFloat = 0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2, height: bounds.height)
    }

    @IBInspectable var fontSize: CGFloat = 16 {
        didSet {
            updateProperties()
        }
    }

    private lazy var sideView : UIView = {
       let sView = UIView()
        sView.backgroundColor = .clear
        return sView
    }()
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = textColorr
        updateProperties()
        setAlignment()
        self.delegate = self
    }
}

extension BaseTextField {
    func updateProperties() {
        if MOLHLanguage.isArabic() {
            let font_ = ArabicFont(weight: isBold ? .bold : .regular)
            font = UIFont(name: font_.fontName, size: fontSize)
        } else {
            let font_ = EnglishFont(isBold ? .medium : .regular)
            font = UIFont(name: font_.fontName, size: fontSize)
        }
    }
    func setAlignment() {
        guard alignmentEnabled else {
            textAlignment = .center
            return }
        textAlignment = MOLHLanguage.isArabic() ? .right : .left
    }
    
    func setUpPlaceHolderColor(){
        let PH_FONT = MOLHLanguage.isArabic() ? ArabicFont(weight: .regular) : EnglishFont(.regular)
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : placeHolderTextColor,NSAttributedString.Key.font : PH_FONT])
        
        if let placeHolder_ = placeholder {
            let place = NSAttributedString(string: placeHolder_, attributes: [.foregroundColor: placeHolderTextColor])
            attributedPlaceholder = place
        }
    }
}



extension BaseTextField: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmpty = textField.text?.isEmpty ?? false
        if isEmpty {
            // show Alert
        }
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let txt = textField.text as NSString? {
            let txtAfterUpdate = txt.replacingCharacters(in: range, with: string)
            //            print(txtAfterUpdate)
            //self.text = txtAfterUpdate
            observe(txtAfterUpdate)
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done{
            endEditing(true)
        }
        return true
    }
}
