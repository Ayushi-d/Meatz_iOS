//
//  TimesCollectionViewCell.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/29/21.
//

import UIKit

class TimesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: BaseLabel!
    
    var isToday: Bool = false
    
    override var isSelected: Bool {
        didSet {
            
            containerView.backgroundColor = isSelected ? R.color.meatzRed() : UIColor.white
            
            containerView.BorderC = isSelected ? R.color.meatzRed()! : R.color.meatzBlack()!
            
            timeLabel.textColor = isSelected ? UIColor.white : R.color.meatzBlack()
        }
    }
    
    var model: PeriodModel? {
        didSet {
            guard let model = model else { return }
            timeLabel.text = model.from + " " + R.string.localizable.to() + " " + model.to
            
            if isToday && model.active {
                self.isUserInteractionEnabled = false
                containerView.backgroundColor = R.color.lightGray()!
                containerView.BorderC = R.color.appGrayColor()!
                timeLabel.isEnabled = false
            } else {
                self.isUserInteractionEnabled = true
                containerView.backgroundColor = UIColor.white
                containerView.BorderC = R.color.meatzBlack()!
                timeLabel.isEnabled = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
