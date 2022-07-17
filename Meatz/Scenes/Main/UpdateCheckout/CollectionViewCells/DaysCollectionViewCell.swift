//
//  DaysCollectionViewCell.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/29/21.
//

import UIKit

class DaysCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var currentDayView: UIView!
    @IBOutlet weak var dayLabel: BaseLabel!
    @IBOutlet weak var dateLabel: BaseLabel!
    
    
    override var isSelected: Bool {
        didSet {
            
            containerView.backgroundColor = isSelected ? R.color.meatzRed() : UIColor.white
            
            containerView.BorderC = isSelected ? R.color.meatzRed()! : R.color.appGrayColor()!
            
            dateLabel.textColor = isSelected ? UIColor.white : R.color.meatzBlack()
            
            dayLabel.textColor = isSelected ? UIColor.white : R.color.meatzBlack()
        }
    }
    
    var model: DayModel? {
        didSet {
            guard let model = model else { return }
            
            if model.today || !model.active {
                containerView.backgroundColor = R.color.appGrayColor()!
                self.isUserInteractionEnabled = false
            } else {
                containerView.backgroundColor =  UIColor.white
                self.isUserInteractionEnabled = true
            }
            
            currentDayView.isHidden = !model.today
            dayLabel.text = model.weekday
            dateLabel.text = model.day
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
