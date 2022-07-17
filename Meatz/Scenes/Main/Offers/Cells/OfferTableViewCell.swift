//
//  OfferTableViewCell.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/19/21.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var offerImageView: UIImageView!
    @IBOutlet private weak var OfferNameLabel: MediumLabel!
    @IBOutlet private weak var numberOfPersonLabel: MediumLabel!
    @IBOutlet private weak var offerMainPriceLabel: MediumLabel!
    @IBOutlet private weak var offerPriceLabel: BaseLabel!
    
    var model: BoxModel? {
        didSet {
            guard let model = model else { return }
            offerImageView.loadImage(model.logoImage)
            OfferNameLabel.text = model.boxName
            offerPriceLabel.text = model.priceBefore
            offerMainPriceLabel.text = "\(model.price) \(R.string.localizable.kwd())  "
            numberOfPersonLabel.text = model.persons.toString
            selectionStyle = .none
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
