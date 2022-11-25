//
//  OrderProductCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/17/21.
//

import UIKit

final class OrderProductCell: UITableViewCell {

    @IBOutlet private weak var shopImageView: UIImageView?
    @IBOutlet private weak var priceLabel: MediumLabel?
    @IBOutlet private weak var quantityLabel: BaseLabel?
    @IBOutlet private weak var shopNameLabel: MediumLabel?
    @IBOutlet private weak var optionsLabel: BaseLabel?
    @IBOutlet private weak var productNameLabel: MediumLabel?
    @IBOutlet private weak var productImageView: UIImageView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    var viewModel : OrderProductCellViewModel?{
        didSet{
            guard let vm = viewModel else{return}
            shopNameLabel?.text = vm.storeName
            optionsLabel?.text = vm.optionsString
            shopImageView?.loadImage(vm.storeImage)
            priceLabel?.text = vm.priceString
            quantityLabel?.text = vm.quantityString
            productNameLabel?.text = vm.productName
            productImageView?.loadImage(vm.productImage)
        }
    }

}


protocol OrderProductCellViewModel {
    var storeName : String{get}
    var storeImage : String{get}
    var priceString : String{get}
    var quantityString : String{get}
    var productImage : String{get}
    var optionsString:String{get}
    var productName : String{get}
    var ItemType : OrderItemType{get}
    var personsCount: String{get}
}
