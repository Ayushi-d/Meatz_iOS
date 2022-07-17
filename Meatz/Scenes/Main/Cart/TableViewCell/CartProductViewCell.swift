//
//  CartProductViewCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/22/21.
//

import UIKit

protocol ChangeCountProtocol:class{
    func didIncreaseCount<T>(_ item: T)
    func didDecreaseCount<T>(_ item: T)
}

class CartProductViewCell: UITableViewCell {

    @IBOutlet weak var priceLbl: MediumLabel?
    @IBOutlet weak var storeNameLbl: MediumLabel?
    @IBOutlet weak var storeIcon: UIImageView?
    @IBOutlet weak var optionsLbl: BaseLabel?
    @IBOutlet weak var nameLbl: MediumLabel?
    @IBOutlet weak var imageView_: UIImageView?
    @IBOutlet weak var countLbl: BoldLabel?
    @IBOutlet weak var containerView: BaseView?
    @IBOutlet weak var counterView: BaseView?
    
    weak var delegate: DeleteItemProtocol?
    weak var countChangingDelegate:ChangeCountProtocol?

    var model: CartProductsModel? {
        didSet {
            guard let data = model else { return }
            priceLbl?.text = data.price + " " + R.string.localizable.kwd()
            optionsLbl?.text = data.options.map { $0.name }.joined(separator: ", ")
            nameLbl?.text = data.name
            imageView_?.loadImage(data.image)
            countLbl?.text = data.count.toString
            storeIcon?.loadImage(data.store.image)
            storeNameLbl?.text = data.store.name
            counterView?.layer.borderWidth = 1
        }
    }

    @IBAction func increaseCountAction(_ sender: Any) {
        guard let product = model else {return}
        countChangingDelegate?.didIncreaseCount(product)
    }

    @IBAction func decreaseCountAction(_ sender: Any) {
        guard let product = model else {return}
        countChangingDelegate?.didDecreaseCount(product)
    }

    @IBAction func deleteItem(_ sender: Any) {
        containerView?.transform = .identity
        guard let product = model else {return}
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
