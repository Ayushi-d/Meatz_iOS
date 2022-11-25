//
//  BaseTextView.swift
//  Asnan Tower
//
//  Created by Mohamed Zead on 1/20/21.
//  Copyright © 2021 Spark Cloud. All rights reserved.
//

import UIKit

class BaseTextView: UITextView {
    public var observe: (String?) -> () = { _ in }
    @IBInspectable var alignmentEnabled: Bool = true {
        didSet {
            setAlignment()
        }
    }

    @IBInspectable var placeholder : String = ""{
        didSet{
            updateProperties()
        }
    }
    @IBInspectable var isBold: Bool = false {
        didSet {
            updateProperties()
        }
    }

    @IBInspectable var fontSize: CGFloat = 16 {
        didSet {
            updateProperties()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateProperties()
        setAlignment()
        self.delegate = self
    }
    
    func set(_ txt : String){
        guard !txt.isEmpty else{
            textColor = R.color.meatzBlack()
            text = placeholder
            return}
        text = txt
        textColor = R.color.meatzBlack()
        
    }
}

extension BaseTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let txt = textView.text as NSString? {
            let txtAfterUpdate = txt.replacingCharacters(in: range, with: text)
            observe(txtAfterUpdate)
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.isEmpty else{
            textColor = .lightGray
            return
        }
        updateProperties()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        text = ""
        textColor = .black
    }
}

extension BaseTextView {
    func updateProperties() {
        
        if MOLHLanguage.isArabic() {
            let font_ = ArabicFont(weight:isBold ? .bold  : .regular)
            font = UIFont(name: font_.fontName, size: fontSize)
        } else {
            let font_ = EnglishFont(isBold ? .medium : .regular)
            font = UIFont(name: font_.fontName, size: fontSize)
        }
        text = placeholder
        textColor = UIColor.placeholderText
    }

    func setAlignment() {
        guard alignmentEnabled else {
            textAlignment = .center
            return }
        textAlignment = MOLHLanguage.isArabic() ? .right : .left
    }
}

