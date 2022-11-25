//
//  SearchItemCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/4/21.
//

import UIKit

final class SearchItemCell: UITableViewCell {
    @IBOutlet private var itemImageView: UIImageView?
    @IBOutlet private var nameLabel: MediumLabel?
    @IBOutlet private var priceLabel: BaseLabel?

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }

    var viewModel: Listable? {
        didSet {
            guard let vm = viewModel else { return }
            itemImageView?.loadImage(vm.imageLink)
            nameLabel?.text = vm.itemName
            priceLabel?.text = vm.cost
        }
    }
}
