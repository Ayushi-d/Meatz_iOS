//
//  WishlistCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/12/21.
//

import UIKit

final class WishlistCell: UICollectionViewCell {
    @IBOutlet private var priceLabel: BaseLabel?
    @IBOutlet private var productNameLabel: BaseLabel?
    @IBOutlet private var productImageView: UIImageView?
    @IBOutlet weak var offerPriceLbl: UILabel!
    var didPressFavIcon: ((_ item : Listable) -> Void)?
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }

    var viewModel: Listable? {
        didSet {
            guard let vm = viewModel else { return }
            productNameLabel?.text = vm.itemName
            productImageView?.loadImage(vm.imageLink)
            priceLabel?.text = vm.cost
            offerPriceLbl.text = vm.costBefore
        }
    }

    @IBAction func removeFromWishlist(_ sender: UIButton) {
        guard let vm = viewModel ,let handler = didPressFavIcon else{return}
        handler(vm)
    }
}
