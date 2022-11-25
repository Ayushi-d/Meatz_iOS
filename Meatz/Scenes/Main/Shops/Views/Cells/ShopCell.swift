//
//  ShopCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/28/21.
//

import UIKit

final class ShopCell: UICollectionViewCell {
    @IBOutlet private var shopImageView: UIImageView?
    @IBOutlet private var logoImageView: UIImageView?
    @IBOutlet private var shopTitleLabel: BaseLabel?
    @IBOutlet private var ratingLabel: UIButton?
    @IBOutlet private var tagsLabel: UILabel?
    var tagArray = [String]()

    var viewModel: Listable? {
        didSet {
            guard let vm = viewModel else { return }
            shopImageView?.loadImage(vm.bannerLink.isEmpty ? vm.imageLink : vm.bannerLink)
            logoImageView?.loadImage(vm.imageLink)
            shopTitleLabel?.text = vm.itemName
            ratingLabel?.setTitle( vm.rating.contains(".") ? "\(vm.rating) " : "\(vm.rating).0 " , for: .normal)
            if !vm.tags.isEmpty{
                tagArray.removeAll()
                for i in vm.tags{
                    tagArray.append(i.name)
                }
                self.tagsLabel?.text = tagArray.joined(separator: ",")
            }
        }
    }
}
