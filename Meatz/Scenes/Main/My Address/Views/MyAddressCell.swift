//
//  MyAddressCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/13/21.
//

import UIKit

final class MyAddressCell: UITableViewCell {
    @IBOutlet private var containerView: BaseView?
    @IBOutlet private var titleLabel: MediumLabel?
    @IBOutlet private var descriptionLabel: BaseLabel?
    var onEditing: ((_ vm: MyAddressCellViewModel) -> Void)?
    var onDeleting: ((_ vm: MyAddressCellViewModel) -> Void)?
    var viewModel: MyAddressCellViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            titleLabel?.text = vm.title
            descriptionLabel?.text = vm.desc
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        onEditing = nil
        onDeleting = nil
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

    @IBAction func deleteAddress(_ sender: Any) {
        containerView?.transform = .identity
        guard let deletingAction = onDeleting, let vm = viewModel else { return }
        deletingAction(vm)
    }

    @IBAction func edit(_ sender: UIButton) {
        guard let editAction = onEditing, let vm = viewModel else { return }
        editAction(vm)
    }
}

protocol MyAddressCellViewModel {
    var title: String { get }
    var desc: String { get }
    var ItemID: Int { get }
    var orderDetailsAddress:String {get}
}
