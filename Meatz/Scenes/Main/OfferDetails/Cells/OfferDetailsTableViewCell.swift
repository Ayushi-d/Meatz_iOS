//
//  OfferDetailsTableViewCell.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/20/21.
//

import UIKit

class OfferDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var contentLabel: UILabel!
    
    var model: String? {
        didSet {
            guard let model = model else { return }
            contentLabel.text = model
            selectionStyle = .none
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
