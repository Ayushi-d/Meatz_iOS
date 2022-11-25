//
//  CartController.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/22/21.
//

import UIKit

final class CartController: MainView {
    // MARK: - ViewModel

    private var viewModel: CartVMProtocol?
    
    func setViewModel(_ viewModel: CartVMProtocol?) {
        self.viewModel = viewModel
    }

    // MARK: - Outlets
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var itemsCountLbl: MediumLabel!
    @IBOutlet weak var subTotalLbl: BaseLabel!
    @IBOutlet weak var containerViewHeader: UIStackView!
    @IBOutlet weak var priceContainerView: UIStackView!
    @IBOutlet weak var pricesStackView: UIStackView!
    @IBOutlet weak var proceedCheckoutBtn: BoldButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.priceContainerView.isHidden = true
        self.proceedCheckoutBtn.isHidden = true
        
        addNavigationItems(cartEnabled: false)
        setupTableView()
        onError()
        onCompletion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        viewModel?.viewDidLoad()
    }

    @IBAction func proceedCheckoutAction(_ sender: Any) {
        guard userCanCheckout()  else {return}
        viewModel?.continuetoCheckout()
    }
    
    private func userCanCheckout()->Bool{
        if !viewModel!.userCanCheckout {
            
            let message = ((viewModel?.notAvailableItems ?? []).joined(separator: ", ")) + " " + R.string.localizable.notAvailableYouNeedToUpdateCart()
            self.showDialogue(R.string.localizable.outOfStock(), message, R.string.localizable.update()) {
                self.viewModel?.clearUnAvailableItemsFromCart()
                self.viewModel?.continuetoCheckout()
               
            }
            return false
        }
        return true
    }
}

// MARK: - Update UI

private extension CartController {
    func onError() {
        viewModel?.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.hideLoading()
            self.showToast("", err.describtionError, completion: nil)
        }
    }

    func onCompletion() {
        viewModel?.onRequestCompletion = { [weak self] msg in
            guard let self = self else { return }
            self.hideLoading()
            let isEmpty = self.viewModel?.numberOfItems == 0
            self.messageView(R.string.localizable.yourCartIsEmpty(),
                             nil,
                             hide: !isEmpty)
            self.priceContainerView.isHidden = isEmpty
            self.proceedCheckoutBtn.isHidden = isEmpty
            self.pricesStackView.isHidden = isEmpty

            self.cartTableView?.reloadData()
            guard !isEmpty else {return}
            guard !msg!.isEmpty else { return }
            self.showToast("", msg ?? "", completion: nil)
        }
        
        viewModel?.model.binding = { [weak self] data in
            guard let self = self else { return }
            self.itemsCountLbl.text = self.viewModel?.numberOfItems.toString
           // self.productTotalLbl.text =  (data?.total)! + " " + R.string.localizable.kwd()
           // self.deliveryCharageLbl.text = (data?.delivery)! + " " + R.string.localizable.kwd()
            self.subTotalLbl.text = (data?.subtotal)! + " " + R.string.localizable.kwd()  
        }
        
        viewModel?.showIndicator.binding = { [weak self] status in
            guard let self = self else { return }
            if status ?? true {
                self.showActivityIndicator()
            } else {
                self.hideActivityIndicator()
            }
        }
    }
}

// MARK: - TabeView Adapter

extension CartController: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        cartTableView.delegate = self
        cartTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel?.dequeCellForRow(at: indexPath).type {
        case .box, .specialBox:
            let cell = tableView.dequeue(CartBoxViewCell.self, indexPath: indexPath)
            cell.model = viewModel?.dequeCellForRow(at: indexPath)
            cell.delegate = viewModel as? DeleteItemProtocol
            cell.countChangingDelegate = viewModel as? ChangeCountProtocol
            return cell

        case .product:
            let cell = tableView.dequeue(CartProductViewCell.self, indexPath: indexPath)
            cell.model = viewModel?.dequeCellForRow(at: indexPath)
            cell.delegate = viewModel as? DeleteItemProtocol
            cell.countChangingDelegate = viewModel as? ChangeCountProtocol
            return cell
        default: return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = viewModel?.dequeCellForRow(at: indexPath).type
        if type == .product {
            
            let height: CGFloat = (viewModel?.optionsIsEmpty(at: indexPath))! ? 170 : 185
            return height
        } else {
            return 145
        }
    }
}


// MARK:- Loading
extension CartController {
    func showLoading(){
        startShimmerAnimation()
        cartTableView?.startShimmerAnimation(withIdentifier: CartProductViewCell.identifier)
 
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        cartTableView?.stopShimmerAnimation()
    }
}
