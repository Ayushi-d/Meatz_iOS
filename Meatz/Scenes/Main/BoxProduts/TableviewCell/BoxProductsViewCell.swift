//
//  BoxProductsViewCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/15/21.
//

import UIKit

protocol DeleteItemProtocol: class{
    func didTapDeleteButton<T>(item: T)
}

final class BoxProductsViewCell: UITableViewCell {

    @IBOutlet weak var containerView: BaseView?
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLbl: MediumLabel!
    @IBOutlet weak var optionsLbl: BaseLabel!
    @IBOutlet weak var storeIcon: UIImageView!
    @IBOutlet weak var storeNameLbl: MediumLabel!
    @IBOutlet weak var quantityLbl: BaseLabel!
    @IBOutlet weak var priceLbl: MediumLabel!
    
    weak var delegate: DeleteItemProtocol?
    
    var model: ProductModel? {
        didSet {
            guard let data = model else { return }
            productImage.loadImage(data.image)
            nameLbl.text = data.name
            storeIcon.loadImage(data.store.logo)
            storeNameLbl.text = data.store.name
            quantityLbl.text = data.count.toString
            priceLbl.text = data.total //+ " " + R.string.localizable.kwd()
            optionsLbl.text = data.options.map { $0.name }.joined(separator: ", ")
            selectionStyle = .none
        }
    }
    
    @IBAction func deleteProduct(_ sender: Any) {
        containerView?.transform = .identity
        guard let product = model else { return }
        delegate?.didTapDeleteButton(item: product)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        containerView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onSwipe(_:))))
    }
    
    @objc fileprivate func onSwipe(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: containerView)
        var transform: CGAffineTransform?
        switch sender.state {
        case .changed:
            containerView?.shadowColor = .clear
            
            if MOLHLanguage.isArabic() {
                guard translation.x > 0 else { return }
            } else {
                guard translation.x < 0 else { return }
            }
            
            transform = CGAffineTransform(translationX: translation.x, y: 0)
            print(translation.x)
        case .ended:
            
            if MOLHLanguage.isArabic() {
                transform = translation.x >= -60 ? CGAffineTransform(translationX: 60, y: 0) : .identity
            } else {
                transform = translation.x <= -60 ? CGAffineTransform(translationX: -60, y: 0) : .identity
            }
            
            if transform == .identity {
                containerView?.shadowColor = R.color.meatzBg()!
            } else {
                containerView?.shadowColor = .clear
            }
        default:
            break
        }
        UIView.animate(withDuration: 0.0) {
            self.containerView?.transform = transform ?? .identity
        }
    }
}
