//
//  FilterTableViewCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import Foundation

import UIKit

final class FilterTableViewCell: UITableViewCell {
    @IBOutlet private var checkBoxImageView: UIImageView?
    @IBOutlet private var optionTitlLabel: BaseLabel?

    var option: FilterTableViewCellViewModel? {
        didSet {
            guard let option_ = option else { return }
            optionTitlLabel?.text = option_.optionTitle
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        checkBoxImageView?.image = selected ? R.image.filterCheckBox() : R.image.blankCheckbox()
        optionTitlLabel?.textColor = selected ? R.color.meatzRed() : R.color.meatzBlack()
    }
}



protocol FilterTableViewCellViewModel {
    var optionTitle : String{get}
}
