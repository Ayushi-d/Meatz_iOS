//
//  WalletCollectionViewCell.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/22/21.
//

import UIKit

class WalletCollectionViewCell: UICollectionViewCell {
    
    var rechargeAction: () -> () = { }
    
    @IBOutlet weak var amountLabel: MediumLabel!
    @IBOutlet weak var currencyLabel: BoldLabel!
    @IBOutlet weak var deciamlLabel: MediumLabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var model: RechargePackageModel? {
        didSet {
            guard let model = model else { return }
            amountLabel.text = model.price
            currencyLabel.text = R.string.localizable.kwd()
            deciamlLabel.text = "." + model.decimal
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if MOLHLanguage.isArabic() {
            stackView.semanticContentAttribute = .forceLeftToRight
        }
       
    }
    
    @IBAction func rechargeButtonTapped(_ sender: Any) {
        rechargeAction()
        
    }
    
}
