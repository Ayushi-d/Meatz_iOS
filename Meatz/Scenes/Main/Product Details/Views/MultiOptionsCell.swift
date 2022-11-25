//
//  MultiOptionsCell.swift
//  Meatz
//
//

import UIKit

protocol PriceUpdate {
    
    func updatePrice(price: String, isAdded : Bool, index: Int)
}

class MultiOptionsCell: UITableViewCell {
    @IBOutlet weak var productoptionTableView : UITableView!
    @IBOutlet weak var extrasLabel : UILabel!
    
    var viewModel: ProductDetailsVMProtocol!
    var delegatePrice : PriceUpdate?
    override func awakeFromNib() {
        super.awakeFromNib()
        productoptionTableView.estimatedRowHeight = 60.0
        productoptionTableView.rowHeight = UITableView.automaticDimension
        self.productoptionTableView.delegate = self
        self.productoptionTableView.dataSource = self
        self.productoptionTableView.reloadData()
        self.productoptionTableView.allowsMultipleSelection = true
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        option = nil
    }
    
//    override var intrinsicContentSize: CGSize {
//       self.layoutIfNeeded()
//       return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height + 20)
//     }
    var multioption : OptionItems?
    
    var option : ExtraOption?{
        didSet{
            guard let option_ = option else{return}
            extrasLabel?.text = option_.name
            self.productoptionTableView.reloadData()
           // priceLabel?.text = option_.price.addCurrency()
            selectionStyle = .none
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MultiOptionsCell : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option?.product_option_items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = productoptionTableView.dequeueReusableCell(withIdentifier: "ProductOptionCell", for: indexPath) as? ProductOptionCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        cell.optionTitleLabel?.text = option?.product_option_items[indexPath.row].name
        guard let opt = option else {return UITableViewCell()}
        cell.priceLabel?.text = "\(opt.product_option_items[indexPath.row].price ?? 0.0)".addCurrency()
        //  cell.option = viewModel.optionForMutliCell(at: indexPath.row)//
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         //viewModel.didSelectOption(at: indexPath.row)
        if let cell = tableView.cellForRow(at: indexPath) as? ProductOptionCell{
            cell.checkBoxImageView?.image = R.image.filterCheckBox()
            guard let opt = option else {return}
            let optionPrice = Double(opt.product_option_items[indexPath.row].price ?? 0.0)
            print(optionPrice)
            print(opt.product_option_items,"abc")
            print(opt.product_option_items[indexPath.row].price,"bcd")
            viewModel.didSelectOption(at: indexPath.row)
                delegatePrice?.updatePrice(price: "\(optionPrice)", isAdded: true, index: indexPath.row)
            
        }
        
         
//         let optionPrice = viewModel.detectOptionPrice(at: indexPath.row)
//         print(optionPrice)
         
//        guard let currentPrice = Double(totalPriceLabel?.text ?? "") else { return }
//        self.optionPrice += optionPrice
//        self.optionsCount += 1
//        let productCount = self.QuantityLabel?.text?.toDouble
//        let total = (optionPrice * productCount!) + currentPrice
//        totalPriceLabel?.text = "\(total)".convertToKwdFormat()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         //viewModel.didDeSelectOption(at: indexPath.row)
        if let cell = tableView.cellForRow(at: indexPath) as? ProductOptionCell{
            cell.checkBoxImageView?.image = R.image.blankCheckbox()
            guard let opt = option else {return}
            let optionPrice = Double(opt.product_option_items[indexPath.row].price ?? 0.0)
            print(optionPrice)
            viewModel.didDeSelectOption(at: indexPath.row)
            delegatePrice?.updatePrice(price: "\(optionPrice)", isAdded: false,index: indexPath.row)
        }

//        guard let currentPrice = Double(totalPriceLabel?.text ?? "") else { return }
//        self.optionsCount -= 1
//        self.optionPrice -= optionPrice
//        let productCount = self.QuantityLabel?.text?.toDouble
//        let total = currentPrice - (optionPrice * productCount!)
//        totalPriceLabel?.text = "\(total)".convertToKwdFormat()
    }
    
    
}


class MyOwnTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet{
            layoutIfNeeded()
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
