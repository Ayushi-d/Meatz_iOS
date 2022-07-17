//
//  OffersCategoryCell.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/19/21.
//

import UIKit

class OffersCategoryCell: UICollectionViewCell {
    
//    override var isSelected: Bool {
//        didSet {
//            containerView.layer.borderWidth = isSelected ? 3 : 0
//            containerView.layer.borderColor = isSelected ? R.color.meatzRed()?.cgColor : UIColor.clear.cgColor
//        }
//    }
    
    @IBOutlet private weak var containerView: BaseView!
    @IBOutlet private weak var selectedBorderView: BaseView!
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var categoryNameLabel: MediumLabel!
    
    var model: CategoryModel? {
        didSet {
            guard let model = model else { return }
            categoryImageView.loadImage(model.image)
            categoryNameLabel.text = model.name
            containerView.layer.borderWidth = model.selected ? 3 : 0
            containerView.layer.borderColor = model.selected ? R.color.meatzRed()?.cgColor : UIColor.clear.cgColor
            selectedBorderView.layer.borderWidth = model.selected ? 3 : 0
            selectedBorderView.layer.borderColor = model.selected ? UIColor.white.cgColor : UIColor.clear.cgColor
        }
    }
}
