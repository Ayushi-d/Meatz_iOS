//
//  BoxesViewCell.swift
//  Meatz
//
//  Created by Nabil Elsherbene on 4/14/21.
//

import UIKit

final class BoxesViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: MediumLabel!
    @IBOutlet weak var priceLbl: BoldLabel!
    @IBOutlet weak var countLbl: BaseLabel!
    @IBOutlet weak var viewDetailsButton: MediumButton!
    @IBOutlet weak var addToCartButton: MediumButton!
    @IBOutlet weak var noItemsInBoxContainer: UIStackView!
    @IBOutlet weak var containerView: BaseView?
    @IBOutlet weak var addToCartHConstraint: NSLayoutConstraint!

    var deleteButonAction: ()->Void = {}
    var addToCartButonAction: (_ isActive: Int)->Void = {_ in }
    var viewItemsButtonAction: ()->Void = {}

    var model: BoxesDataModel? {
        didSet {
            guard let model_ = model else { return }
            nameLbl.text = model_.name
            priceLbl.text = model_.total + " " +  R.string.localizable.kwd() 
            countLbl.text = model_.itemsCount.toString
            noItemsInBoxContainer.isHidden = model?.itemsCount == 0 ? false : true
            addToCartHConstraint.constant = model?.itemsCount == 0 ? 0 : 38
            addToCartButton.isHidden = model?.itemsCount == 0 ? true : false
            
            drawBtns()
            selectionStyle = .none
        }
    }

    @IBAction func deleteAddress(_ sender: Any) {
        containerView?.transform = .identity
        deleteButonAction()
    }

    @IBAction func addToCart(_ sender: Any) {
        addToCartButonAction(model?.isActive ?? 0)
    }

    @IBAction func viewAllDetails(_ sender: Any) {
        viewItemsButtonAction()
    }

   private  func drawBtns(){
        viewDetailsButton.layer.maskedCorners = [Corners.topLeft, Corners.bottomRight]
        addToCartButton.layer.maskedCorners = [Corners.topRight, Corners.bottomLeft]
        addToCartButton.cornerRadius = 10
        viewDetailsButton.cornerRadius = 10
        viewDetailsButton.clipsToBounds = true
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
