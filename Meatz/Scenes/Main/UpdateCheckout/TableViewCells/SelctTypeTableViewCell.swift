//
//  SelctTypeTableViewCell.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/29/21.
//

import UIKit

class SelctTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var titleLabel: BaseLabel!
    @IBOutlet weak var walletValueLabel: MediumLabel!
    @IBOutlet weak var valueLabel: BaseLabel!
    
    
    var model: SelectionTypeProtocol? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            valueLabel.text = model.titleValue
            walletValueLabel.text = model.walletValue
            
            if !model.isValiable {
                titleLabel.isEnabled = false
                valueLabel.isEnabled = false
                walletValueLabel.isEnabled = false
                selectedImageView.isHighlighted = true
                self.isUserInteractionEnabled = false
            }
            
            selectionStyle = .none
        }
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            selectedImageView?.image = R.image.selectRadio()
            titleLabel?.textColor = R.color.meatzRed()
        } else {
            selectedImageView?.image = R.image.nSeleectRadio()
            titleLabel?.textColor = R.color.meatzBlack()
        }
//        selectedImageView?.image = selected ? R.image.selectRadio() : R.image.nSeleectRadio()
//        
//        titleLabel?.textColor = selected ? R.color.meatzRed() : R.color.meatzBlack()
        
    }
    
}
