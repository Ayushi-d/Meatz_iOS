//
//  SearchStoreCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/4/21.
//

import UIKit

final class SearchStoreCell: UITableViewCell {
    @IBOutlet private var storeNameLabel: MediumLabel?
    @IBOutlet private var storeImageView: UIImageView?

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }

    var viewModel: Listable? {
        didSet {
            guard let vm = viewModel else { return }
            storeNameLabel?.text = vm.itemName
            storeImageView?.loadImage(vm.imageLink)
        }
    }
}
