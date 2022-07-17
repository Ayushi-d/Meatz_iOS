//
//  ShopCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/28/21.
//

import UIKit

final class ShopCell: UICollectionViewCell {
    @IBOutlet private var shopImageView: UIImageView?
    @IBOutlet private var shopTitleLabel: BaseLabel?

    var viewModel: Listable? {
        didSet {
            guard let vm = viewModel else { return }
            shopImageView?.loadImage(vm.imageLink)
            shopTitleLabel?.text = vm.itemName
        }
    }
}
