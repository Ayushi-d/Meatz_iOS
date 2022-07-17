//
//  UpdateCheckoutViewController.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/29/21.
//

import UIKit

class UpdateCheckoutViewController: MainView {
    
    @IBOutlet weak var selectAddressPicker: PickerViewTextField?
    @IBOutlet weak var addressDetailsView: UIStackView!
    @IBOutlet weak var userDetailsView: UIStackView!
    @IBOutlet weak var noAddressSelectedView: UIStackView!
    @IBOutlet weak var addAddressView: UIStackView!
    @IBOutlet weak var AddressNameLabel: BoldLabel!
    @IBOutlet weak var emailLabel: BoldLabel!
    @IBOutlet weak var phoneLabel: BoldLabel!
    @IBOutlet weak var addressDetailsLabel: BaseLabel!
    
    @IBOutlet weak var paymentMethodTableView: UITableView!
    @IBOutlet weak var deliveryTypeTableView: UITableView!
    
    @IBOutlet weak var datePeriodLabel: MediumLabel!
    @IBOutlet weak var dayesCollectionView: UICollectionView!
    @IBOutlet weak var timesCollectionView: UICollectionView!
    
    @IBOutlet weak var timesView: UIView!
    @IBOutlet weak var dayesView: UIStackView!
    @IBOutlet weak var expressView: UIStackView!
    @IBOutlet weak var expressTitleLabel: BaseLabel!
    
    @IBOutlet weak var copounView: UIStackView!
    @IBOutlet weak var compounTextField: BaseTextField!
    @IBOutlet weak var copounMessageLabel: BaseLabel!
    @IBOutlet weak var compounMessageImage: UIImageView!
    
    @IBOutlet weak var productsTotalLabel: BaseLabel!
    @IBOutlet weak var deliveryChargeLabel: BaseLabel!
    @IBOutlet weak var discountLabel: BaseLabel!
    @IBOutlet weak var totalLabel: MediumLabel!
    
    var viewModel: UpdateCheckoutVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setAddressObservables()
        setupDeliveryTypeLists()
        setupPaymentMethodLists()
        setExpressViewObservable()
//        setNormalViewObservable()
        checkoutDetailsObserver()
        indicatorStatus()
        setupCompletion()
        setupTimeListAdapter()
        setupDayesListAdapter()
        observeCouponField()
        onError()
        addLogoTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectAddressPicker?.text = ""
        timesView.isHidden = true
        dayesView.isHidden = true
        expressView.isHidden = true
        copounView.isHidden = true
        
        if viewModel.isCheckoutAsGuest {
            addressDetailsView.isHidden = false
            noAddressSelectedView.isHidden = true
        } else {
            addressDetailsView.isHidden = true
            noAddressSelectedView.isHidden = false
        }
        
        viewModel.viewDidLoad()
    }
    
    fileprivate func observeCouponField() {
        
        compounTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.couponParams.code = text ?? ""
        }
    }
    
    fileprivate func setupCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.setAddresscheckForGuest()
            
        }
        
        viewModel.couponApplied.binding = { [weak self] isApplied in
            guard let self = self, let isApplied_ = isApplied else { return }
            self.copounView?.isHidden = false
            self.copounMessageLabel?.text = isApplied_ ? R.string.localizable.promoCodeApplied() : R.string.localizable.invalidCode()
            
            self.copounMessageLabel?.textColor = isApplied_ ? R.color.meatzSuccess() : R.color.meatzError()
            
            self.compounMessageImage?.image = isApplied_ ? R.image.promoApplied() : R.image.invalidCode()
            self.compounTextField?.text = ""
            self.hideActivityIndicator()
        }
        
        viewModel.coponData.binding = { [weak self] result in
            guard let self = self else { return }
            guard let data = result else { return }
            if data.used {
                self.showToast("", data.message, completion: nil)
                self.copounView?.isHidden = true
            }

        }
    }
    
    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] err in
            guard let self = self, let error = err else { return }
            self.hideActivityIndicator()
            self.showToast("", error.describtionError, completion: nil)
        }
    }
    
    fileprivate func indicatorStatus() {
        viewModel.showActivityIndicator.binding = { [weak self] status in
            guard let self = self else { return }
            switch status {
            case true:
                self.showActivityIndicator()
            case false:
                self.hideActivityIndicator()
            default: break
            }
        }
    }
    
    fileprivate func checkoutDetailsObserver() {
        viewModel.checkoutDetails.binding = { [weak self] details in
            guard let self = self else { return }
            guard let details = details else { return }
            
            self.totalLabel.text = details.total.toString.convertToKwdFormat() + "" + R.string.localizable.kwd()
            
            self.productsTotalLabel.text = details.subtotal.toString.convertToKwdFormat() + "" + R.string.localizable.kwd()
            
            self.discountLabel.text = details.discount.toString.convertToKwdFormat() + "" + R.string.localizable.kwd()
            
            self.deliveryChargeLabel.text = details.delivery.toString.convertToKwdFormat() + "" + R.string.localizable.kwd()
            
            self.expressTitleLabel.text = details.expressDeliveryMessage
            
            self.datePeriodLabel.text = details.periodTitle
            
        }
    }
    
    private func setAddressObservables() {
        
        addressDetailsView.isHidden = true
        
        viewModel.addresses.binding = { [weak self] addresses in
            guard let self = self else { return }
            guard let addresses = addresses else { return }
            self.selectAddressPicker?.isHidden = addresses.isEmpty
            self.selectAddressPicker?.items = addresses
        }
        
        selectAddressPicker?.didSelectItemAtRow = { [weak self] index in
            guard let self = self else { return }
            self.viewModel.createDeliveryTypeForUser(index: index)
        }
        
        viewModel.selectedAddress?.binding = { [weak self] address in
            guard let self = self else { return }
            self.noAddressSelectedView.isHidden = true
            self.addressDetailsView.isHidden = false
            self.userDetailsView.isHidden = true
            self.AddressNameLabel.text = address?.addressName ?? ""
            self.addressDetailsLabel.text = address?.orderDetailsAddress ?? ""
        }
    }
    
    private func setExpressViewObservable() {

        viewModel.showExpressDeliveryView.binding = { [weak self] status in
            guard let self = self else { return }
            guard let status = status else { return }
            self.expressView.isHidden = !status
            self.dayesView.isHidden = status
            self.timesView.isHidden = true
            self.dayesCollectionView.reloadData()
        }
    }
    
    private func setNormalViewObservable() {

        viewModel.showNormalView.binding = { [weak self] status in
            guard let self = self else { return }
            guard let status = status else { return }
            self.dayesView.isHidden = !status
            self.timesView.isHidden = true
        }
    }
    
    fileprivate func setAddresscheckForGuest(){
        guard viewModel.isCheckoutAsGuest else {
            return
        }
        addAddressView.isHidden = true
        noAddressSelectedView.isHidden = true
        addressDetailsView.isHidden = false
        selectAddressPicker?.text = viewModel.guestAddress?.addressName
        selectAddressPicker?.isEnabled = false
        AddressNameLabel.text = viewModel.guestAddress?.customerName
        emailLabel.text = viewModel.guestAddress?.email
        phoneLabel.text = viewModel.guestAddress?.mobile
        addressDetailsLabel.text = viewModel.guestAddress?.descAddressForGuest
        viewModel.createDeliveryTypeForGuest()
    }
    
    fileprivate func setupDeliveryTypeLists() {
        
        deliveryTypeTableView.register(R.nib.selctTypeTableViewCell)
        
        deliveryTypeTableView.dataSource = self
        deliveryTypeTableView.delegate = self
        
        viewModel.deliveryTypeItems.binding = { [weak self] types in
            guard let self = self else { return }
            self.deliveryTypeTableView.reloadData()
        }
        
        viewModel.unSelectDeliveryType.binding = { [weak self] index in
            guard let self = self else { return }

            self.selectTypeCellSelection(tableView: self.deliveryTypeTableView, index: index ?? 0, selected: false)
        }
    }
    
    fileprivate func setupPaymentMethodLists() {
        
        paymentMethodTableView.register(R.nib.selctTypeTableViewCell)
        
        paymentMethodTableView.dataSource = self
        paymentMethodTableView.delegate = self
        
        viewModel.paymentMethodItems.binding = { [weak self] methods in
            guard let self = self else { return }
            self.paymentMethodTableView.reloadData()

            self.selectTypeCellSelection(tableView: self.paymentMethodTableView, index: 0, selected: true)
            
            self.tableView(self.paymentMethodTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        }
    }
    
    private func selectTypeCellSelection(tableView: UITableView ,index: Int, selected: Bool) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! SelctTypeTableViewCell
        cell.setSelected(selected, animated: true)
    }
    
}

extension UpdateCheckoutViewController {
    
    @IBAction func addNewAddressButtonTapped(_ sender: UIButton) {
        viewModel.addAddress()
    }
    
    @IBAction func applyCopounButtonTapped(_ sender: UIButton) {
        viewModel.applyCoupon()
    }
    
    @IBAction func submitOrderButtonTapped(_ sender: UIButton) {
        viewModel.checkout()
    }
    

}

extension UpdateCheckoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case deliveryTypeTableView:
            return viewModel.numberOfDeliveryTypeItems
        case paymentMethodTableView:
            return viewModel.numberOfPaymentMethods
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case deliveryTypeTableView:
            let cell = tableView.dequeue(SelctTypeTableViewCell.self, indexPath: indexPath)
            cell.model = viewModel.getDeliveryTypeModel(at: indexPath.row)
            return cell
            
        case paymentMethodTableView:
            let cell = tableView.dequeue(SelctTypeTableViewCell.self, indexPath: indexPath)
            cell.model = viewModel.getPaymentMethodModel(at: indexPath.row)
            
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case deliveryTypeTableView:
            viewModel.didSelectDeliveryType(at: indexPath.row)
        case paymentMethodTableView:
            if indexPath.row > 0 {
                selectTypeCellSelection(tableView: paymentMethodTableView, index: 0, selected: false)
            }
            viewModel.didSelectPaymentMethod(at: indexPath.row)
        default:
            return
        }
        
        
    }
}


extension UpdateCheckoutViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupDayesListAdapter() {
        
        dayesCollectionView.register(R.nib.daysCollectionViewCell)
        
        dayesCollectionView.dataSource = self
        dayesCollectionView.delegate = self
        
        viewModel.dayes.binding = { [weak self] _ in
            guard let self = self else { return }
            self.dayesCollectionView.reloadData()
            self.dayesView.isHidden = false
        }
        
    }
    
    private func setupTimeListAdapter() {
        timesCollectionView.register(R.nib.timesCollectionViewCell)
        
        timesCollectionView.dataSource = self
        timesCollectionView.delegate = self
        
        viewModel.periods.binding = { [weak self] _ in
            guard let self = self else { return }
            self.timesCollectionView.reloadData()
            self.timesView.isHidden = false
        }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case dayesCollectionView:
            return viewModel.numberOfDayesItems
        case timesCollectionView:
            return viewModel.numberOfPeriodsItems
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case dayesCollectionView:
            let cell = collectionView.dequeue(indexPath: indexPath, type: DaysCollectionViewCell.self)
            cell.model = viewModel.getDayesModel(at: indexPath.item)
            return cell
        case timesCollectionView:
            let cell = collectionView.dequeue(indexPath: indexPath, type: TimesCollectionViewCell.self)
            cell.isToday = viewModel.selectedDateISTody
            cell.model = viewModel.getPeriodModel(at: indexPath.item)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case dayesCollectionView:
            let height = collectionView.frame.height
            return CGSize(width: 52, height: height)
        case timesCollectionView:
            let width = (collectionView.frame.width / 2 ) - 10
            return CGSize(width: width, height: 40)
        default:
            return .zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        switch collectionView {
        case dayesCollectionView:
            return 10
        case timesCollectionView:
            return 10
        default:
            return 0
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        switch collectionView {
        case dayesCollectionView:
            return 0
        case timesCollectionView:
            return 5
        default:
            return 0
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        
        case dayesCollectionView:
            viewModel.didSelectDay(at: indexPath.item)

        case timesCollectionView:
            viewModel.didSelectPeriod(at: indexPath.item)
            
        default:
            return
        }
    }
    
}
