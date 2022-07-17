//
//  HomeBoxCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/30/21.
//

import UIKit

final class HomeBoxCell: UICollectionViewCell {
    @IBOutlet private var priceBeforeView: UIView?
    @IBOutlet private var priceBeforeLabel: BaseLabel?
    @IBOutlet private var priceLabel: BaseLabel?
    @IBOutlet private var boxTitlLabel: BaseLabel?
    @IBOutlet private var boxImageView: UIImageView?
    @IBOutlet private var personsCountLabel: BaseLabel?

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }

    var viewModel: OurBoxViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            priceBeforeLabel?.text = vm.costBefore
            priceBeforeView?.isHidden = vm.costBefore == "0"
            priceLabel?.text = vm.cost
            boxTitlLabel?.text = vm.boxName
            boxImageView?.loadImage(vm.logoImage)
            personsCountLabel?.text = vm.personsCount
        }
    }
}
                   
         
