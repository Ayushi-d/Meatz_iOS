//
//  ShopCategoryCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/28/21.
//

import UIKit

final class ShopCategoryCell: UICollectionViewCell {
    @IBOutlet private var backGroundView: BaseView?
    @IBOutlet private var logoImageView: UIImageView?
    @IBOutlet private var categoryNameLabel: BaseLabel!

    var viewModel: CategoryModel? {
        didSet {
            guard let vm = viewModel else { return }
            categoryNameLabel.text = vm.name
//            categoryNameLabel.textColor = vm.isSelected ? .white : R.color.meatzBlack()
//            backGroundView?.backgroundColor = vm.isSelected ? R.color.meatzRed() : .white
//            logoImageView?.image = vm.isSelected ? vm.categorySelectedImage : vm.categoryImage
            logoImageView?.loadImage(vm.image)
        }
    }
}
