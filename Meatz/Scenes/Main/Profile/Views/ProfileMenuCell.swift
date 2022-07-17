//
//  ProfileMenuCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/11/21.
//

import UIKit

final class ProfileMenuCell: UITableViewCell {

    @IBOutlet private weak var accessoryImageView: UIImageView?
    @IBOutlet private weak var itemImageView: UIImageView?
    @IBOutlet private weak var itemTitleLabel: BaseLabel?
    @IBOutlet private weak var itemValueLabel: BoldLabel?
    
    
    var viewModel : ProfileMenuItemViewModel?{
        didSet{
            guard let vm = viewModel else{return}
            itemImageView?.image = vm.image
            itemTitleLabel?.text = vm.name
            itemValueLabel?.text = vm.value
            accessoryImageView?.image = MOLHLanguage.isArabic() ? R.image.backAr() : R.image.back1()
            
        }
    }
}
