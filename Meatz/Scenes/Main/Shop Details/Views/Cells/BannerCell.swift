//
//  BannerCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import UIKit

final class BannerCell: UICollectionViewCell {
    @IBOutlet private weak var bannerImageView: UIImageView?
    
    var viewModel : Listable?{
        didSet{
            guard let vm = viewModel else{return}
            bannerImageView?.loadImage(vm.imageLink)
        }
    }
}
