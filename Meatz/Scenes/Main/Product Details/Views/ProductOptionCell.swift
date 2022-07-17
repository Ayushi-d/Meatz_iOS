//
//  ProductOptionCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/18/21.
//

import UIKit

final class ProductOptionCell: UITableViewCell {
    
    @IBOutlet   weak var optionTitleLabel: BaseLabel?
    @IBOutlet   weak var priceLabel: BaseLabel?
    @IBOutlet   weak var checkBoxImageView: UIImageView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        option = nil
    }
    
    var option : OptionItems?{
        didSet{
            guard let option_ = option else{return}
            //optionTitleLabel?.text = option_.name
            //priceLabel?.text = option_.price.addCurrency()
            selectionStyle = .none
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       // checkBoxImageView?.image = selected ? R.image.filterCheckBox() : R.image.blankCheckbox()
    }

}
