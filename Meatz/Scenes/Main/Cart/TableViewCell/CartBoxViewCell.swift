//
//  CartBoxViewCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/22/21.
//

import UIKit

final class CartBoxViewCell: CartProductViewCell {

    @IBOutlet weak var boxNameLbl: MediumLabel!
    @IBOutlet weak var personsLbl: BaseLabel!
    

    override var model: CartProductsModel?{
        didSet{
            boxNameLbl.text = model?.name
            personsLbl.text =  (model?.persons.toString)! + " " + R.string.localizable.persons()
            counterView?.layer.borderWidth = 1
        }
    }
    
}
