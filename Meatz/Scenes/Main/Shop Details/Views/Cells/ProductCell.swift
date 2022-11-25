//
//  ProductCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    
    @IBOutlet private weak var priceBeforeLabel: BaseLabel?
    @IBOutlet private weak var priceBeforeView: UIView?
    @IBOutlet private weak var priceLabel: BaseLabel?
    @IBOutlet private weak var productNameLabel: BaseLabel?
    @IBOutlet private weak var productImageView: UIImageView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    var viewModel : Listable?{
        didSet{
            guard let vm = viewModel else{return}
            productNameLabel?.text = vm.itemName
            productImageView?.loadImage(vm.imageLink)
            priceLabel?.text = vm.cost
            priceBeforeLabel?.text = vm.costBefore
            priceBeforeView?.isHidden = vm.costBefore.isEmpty || vm.costBefore == "0"
        }
    }
}
