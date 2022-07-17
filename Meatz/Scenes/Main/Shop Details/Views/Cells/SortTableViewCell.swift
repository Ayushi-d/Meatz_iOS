//
//  SortTableViewCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import Foundation
import UIKit

final class SortTableViewCell: UITableViewCell {
    @IBOutlet private var radioImageView: UIImageView?
    @IBOutlet private var optionTitlLabel: BaseLabel?

    var option: SortTableViewCellViewModel? {
        didSet {
            guard let option_ = option else { return }
            optionTitlLabel?.text = option_.titleString
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        radioImageView?.image = selected ? R.image.selectRadio() : R.image.nSeleectRadio()
        optionTitlLabel?.textColor = selected ? R.color.meatzRed() : R.color.meatzBlack()
    }
}


protocol SortTableViewCellViewModel {
    var titleString : String{get}
}
