//
//  OrderBoxCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/17/21.
//

import UIKit

final class OrderBoxCell: UITableViewCell {

    @IBOutlet private weak var priceLabel: MediumLabel?
    @IBOutlet private weak var quantityLabel: BaseLabel?
    @IBOutlet private weak var personsCountLabel: BaseLabel?
    @IBOutlet private weak var boxNameLabel: MediumLabel?
 
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    var viewModel : OrderProductCellViewModel?{
        didSet{
            guard let vm = viewModel else{return}
            priceLabel?.text = vm.priceString
            quantityLabel?.text = vm.quantityString
            personsCountLabel?.text = vm.personsCount
            boxNameLabel?.text = vm.productName
        }
    }
}


