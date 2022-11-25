//
//  SettingsViewCell.swift
//  Meatz
//
//  Created by Nabil Elsherbene on 4/18/21.
//

import UIKit

final class SettingsViewCell: UITableViewCell {

    @IBOutlet weak var imageView_: UIImageView!
    @IBOutlet weak var titleLbl: BaseLabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    var model: SettingsModel?{
        didSet{
            guard let data = model else {return}
            arrowIcon.image = R.image.back1()?.imageFlippedForRightToLeftLayoutDirection()
            titleLbl.text = data.title
            imageView_.loadImage(data.image)
            selectionStyle = .none
        }
    }
}
