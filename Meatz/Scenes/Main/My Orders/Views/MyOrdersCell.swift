//
//  MyOrdersCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/15/21.
//

import UIKit

final class MyOrdersCell: UITableViewCell {
    @IBOutlet private weak var orderIdLabel: MediumLabel?
    @IBOutlet private weak var itemsCountLabel: BaseLabel?
    @IBOutlet private weak var statusLabel: MediumLabel?
    @IBOutlet private weak var dateLabel: MediumLabel?
    @IBOutlet private weak var priceLabel: BoldLabel?
    @IBOutlet private weak var reorderView: UIView?
    @IBOutlet private weak var statusView: UIView?
    var delegate : Reorderable?
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        statusView?.isHidden = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    var viewModel : MyOrdersCellViewModel?{
        didSet{
            guard let vm = viewModel else{return}
            orderIdLabel?.text = vm.orderID
            itemsCountLabel?.text = vm.count
            statusLabel?.text = vm.statusValue
            dateLabel?.text = vm.orderDate
            priceLabel?.text = vm.price
            reorderView?.isHidden = !vm.isRorderable
            statusView?.isHidden = false
            if MOLHLanguage.isArabic(){
                statusView?.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
            
            }else{
                statusView?.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
            }
        }
    }
    @IBAction func reorder(_ sender : UIButton){
        print(viewModel?.ID)
        delegate?.didReordered(viewModel?.ID ?? 0 )
    }
}


protocol MyOrdersCellViewModel {
    var ID : Int{get}
    var orderID : String{get}
    var orderDate : String{get}
    var price : String{get}
    var count : String{get}
    var statusValue : String{get}
    var isRorderable : Bool{get}
}


protocol Reorderable {
    func didReordered(_ id : Int)
}
