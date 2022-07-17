//
//  String + Extension.swift
//  Asnan Tower
//
//  Created by Mohamed Zead on 12/28/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func convertToKwdFormat() ->String{
        let currencyValue = round(self.toDouble * 1000)/1000
        return String(format: "%.3f", currencyValue)
    }

    func addCurrency() -> String {
        var temp = convertToKwdFormat()
        temp.append(" " + R.string.localizable.kwd())
        return temp
    }

    var toDouble : Double{
        return Double(self) ?? 0.0
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
           let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
       
           return ceil(boundingBox.height)
       }

       func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
           let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

           return ceil(boundingBox.width)
       }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

