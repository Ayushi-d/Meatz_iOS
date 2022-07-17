//
//  AreaCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/13/21.
//

import UIKit

final class AreaCell: UITableViewCell {
    @IBOutlet weak var areaTitlLabel: BaseLabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
