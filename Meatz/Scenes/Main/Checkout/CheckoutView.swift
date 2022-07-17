//
//  CheckoutView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/22/21.
//
import UIKit

final class CheckoutView: MainView {
    // MARK: - Outlets
    
    @IBOutlet private weak var selectedAddressHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selectAddressView: BaseView?
    @IBOutlet private weak var addNewAddressView: UIView?
    @IBOutlet private weak var couponStatusImageView: UIImageView?
    @IBOutlet private weak var couponStatusLabel: BaseLabel?
    @IBOutlet private var totalLabel: MediumLabel?
    @IBOutlet private var discountLabel: BaseLabel?
    @IBOutlet private var deliveryChargeLabel: BaseLabel?
    @IBOutlet private var productsTotalLabel: BaseLabel?
    @IBOutlet private var addressesTableView: UITableView?
    @IBOutlet private var selectedAddressView: BaseView?
    @IBOutlet private var addressDescriptionLabel: BaseLabel?
    @IBOutlet private var addressNameLabel: MediumLabel?
    @IBOutlet private var applyCouponButton: MediumButton?
    @IBOutlet private var couponTextField: BaseTextField?
    @IBOutlet private var couponAppliedView: UIStackView?
    @IBOutlet private var paymentMethodsTableView: UITableView?
    
    // MARK: - Properties
    
    private var isAddressesExpanded: Bool = false
    private var deliveryCost:Double = 0.0
    var viewModel: CheckoutVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel?.text = "\(viewModel.total)".addCurrency()
        addNavigationItems(cartEnabled: false)
        observeCouponField()
        onError()
        onCompletion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showActivityIndicator()
        viewModel.onViewDidLoad()
    }
    fileprivate func observeCouponField() {
        couponTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.couponParams.code = text ?? ""
        }
    }
    
    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] err in
            guard let self = self, let error = err else { return }
            self.hideActivityIndicator()
            self.showToast("", error.describtionError, completion: nil)
        }
    }
    
    fileprivate func onCompletion() {
       
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.loadData()
            self.checkForGuestStatus()
            self.addressesTableView?.reloadData()
        }

        
        viewModel.couponApplied.binding = { [weak self] isApplied in
            guard let self = self, let isApplied_ = isApplied else { return }
            self.couponAppliedView?.isHidden = false
            self.couponStatusLabel?.text = isApplied_ ? R.string.localizable.promoCodeApplied() : R.string.localizable.invalidCode()
            self.couponStatusLabel?.textColor = isApplied_ ? R.color.meatzSuccess() : R.color.meatzError()
            self.couponStatusImageView?.image = isApplied_ ? R.image.promoApplied() : R.image.invalidCode()
            self.couponTextField?.text = ""
            self.loadData()
            self.hideActivityIndicator()
        }
        
        viewModel.coponData.binding = { [weak self] result in
            guard let self = self else { return }
            guard let data = result else { return }
            let total = (self.viewModel.total.toDouble - (data.discount))  + self.deliveryCost + self.viewModel.guestDeliveryCharge
            self.totalLabel?.text = "\(total)".addCurrency()
            self.discountLabel?.text = "\(data.discount)".addCurrency()
            if data.used {
                self.showToast("", data.message, completion: nil)
                self.couponStatusLabel?.isHidden = true
                self.couponStatusImageView?.isHidden = true
            }

        }
    }
    
    fileprivate func loadData(){
        selectAddressView?.isHidden = viewModel.numberOfAddresses == 0
        selectedAddressHeightConstraint.constant = viewModel.numberOfAddresses == 0 ? 0 : 50
        productsTotalLabel?.text = viewModel.productsTotal.addCurrency()
        view.layoutIfNeeded()
    }
    
    fileprivate func checkForGuestStatus(){
        guard viewModel.isCheckoutAsGuest else{return}
        addNewAddressView?.isHidden = true
        selectAddressView?.isHidden = true
        selectAddressView?.isHidden = true
        selectedAddressView?.isHidden = false
        addressDescriptionLabel?.text = viewModel.guestAddressDescription
        deliveryChargeLabel?.text = "\(viewModel.guestDeliveryCharge)".addCurrency()
        totalLabel?.text = "\(viewModel.guestTotalAfterSelectAddress)".addCurrency()
        addressNameLabel?.text = viewModel.guestAddressName
        selectedAddressHeightConstraint.constant = 0
        loadData()
        view.layoutIfNeeded()
    }
}

// MARK: - Actions
extension CheckoutView {
    @IBAction func addNewAddress(_ sender: UIButton) {
        viewModel.addAddress()
    }
    
    @IBAction func selectAddress(_ sender: UIButton) {
        isAddressesExpanded = !isAddressesExpanded
        addressesTableView?.isHidden = !isAddressesExpanded
    }
    
    @IBAction func applyCoupon(_ sender: UIButton) {
        showActivityIndicator()
        viewModel.applyCoupon()
    }
    
    @IBAction func proceedToPayment(_ sender: UIButton) {
        viewModel.checkout()
    }
}

// MARK: - TableView
extension CheckoutView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView == addressesTableView else{
            return viewModel.numberOfMethods
        }
        return viewModel.numberOfAddresses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == addressesTableView {
            let cell = tableView.dequeue(AreaCell.self, indexPath: indexPath)
            cell.areaTitlLabel?.text = viewModel.address(at: indexPath.row).addressName
            return cell
        } else {
            let cell = tableView.dequeue(SortTableViewCell.self, indexPath: indexPath)
            cell.option = viewModel.methodForCell(at: indexPath.row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == addressesTableView {
            loadData()
            let address = viewModel.address(at: indexPath.row)
            deliveryCost = address.area.delivery
            deliveryChargeLabel?.text = "\(address.area.delivery)".addCurrency()
            addressNameLabel?.text = address.addressName
            addressDescriptionLabel?.text = address.desc
            addressesTableView?.isHidden = true
            selectedAddressView?.isHidden = false
            viewModel.didSelectAddress(at: indexPath.row)
            totalLabel?.text = "\((address.area.delivery - viewModel.discount.toDouble ) + viewModel.total.toDouble - 0.0 )".addCurrency()
            
        } else {
            viewModel.didSelectMethod(at: indexPath.row)
        }
    }
}
