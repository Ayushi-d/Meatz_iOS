//
//  CheckoutViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/23/21.
//
import Foundation

final class CheckoutViewModel {
    var state: State = .notStarted
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable(nil)
    var couponParams: CouponParameters!
    var couponApplied: Observable<Bool> = Observable(false)
    var coponData: Observable<CouponModel> = Observable(nil)
    var isCheckoutAsGuest: Bool = false
    var guestAddress: AddressParameters?{
        didSet{
            checkoutParameters.address = guestAddress
        }
    }
    var cartModel: CartDataModel? {
        didSet {
            couponParams = CouponParameters(total: cartModel?.subtotal ?? "")
        }
    }
    
    var disCountValue: String = "0.000"
    var coponCode: String = ""
    private var repo: CheckoutRepoProtocol?
    private var coordinator: Coordinator?
    private var addresses: [AddressModel] = []
    private var areas: [AreaModel] = []
    private var paymentMethods: [PaymentMethod] = [.online, .wallet]
    private var checkoutParameters: CheckoutParameters = CheckoutParameters()
    
    
    init(_ repo: CheckoutRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension CheckoutViewModel: CheckoutVMProtocol {
    var numberOfAddresses: Int {
        return addresses.count
    }
    
    var numberOfMethods: Int {
        return paymentMethods.count
    }
    
    // Cart cost values
    var productsTotal: String {
        return (cartModel?.subtotal ?? "")
    }
    
    var deliveryCharge: String {
        return String(format: "%.3f", (cartModel?.delivery ?? "").toDouble).addCurrency()
    }
    
    var guestDeliveryCharge:Double{
        return guestAddress?.deliveryCost ?? 0.0
    }
    
    var discount: String {
        return disCountValue
    }
    
    var total: String {
        //let totalCost = (cartModel?.subtotal ?? "").toDouble
        return cartModel?.subtotal ?? ""
    }
    
    var guestAddressDescription: String {
        return guestAddress?.descAddressForGuest ?? ""
    }
    
    var guestTotalAfterSelectAddress:Double{
        return (guestDeliveryCharge - discount.toDouble) + total.toDouble
    }
    
    var guestAddressName:String{
        guestAddress?.addressName ?? ""
    }
    
    // Functionality
    func onViewDidLoad() {
        if !isCheckoutAsGuest {
            repo?.getAddresses { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model):
                    self.addresses = model.addresses
                    guard let completion = self.onRequestCompletion else { return }
                    completion("")
                case .failure(let error):
                    self.requestError?.value = error
                }
            }
        }
        
        repo?.getAreas { [weak self] result in
            switch result {
            case .success(let model):
                self?.areas = model.areas
                guard let completion = self?.onRequestCompletion else { return }
                completion("")
            case .failure(let error):
                self?.requestError?.value = error
            }
        }
    }
    
    func methodForCell(at index: Int) -> SortTableViewCellViewModel {
        return paymentMethods[index]
    }
    
    func address(at index: Int) -> AddressModel {
        return addresses[index]
    }
    
    func didSelectAddress(at index: Int) {
        checkoutParameters.addressID = addresses[index].id
        let deliveryCost = addresses[index].area.delivery
        cartModel?.delivery = String(deliveryCost)
    }
    
    func didSelectMethod(at index: Int) {
        checkoutParameters.paymentMethod = paymentMethods[index]
    }
    
    func checkout() {
        guard isCheckoutValid() else { return }
        repo?.checkout(checkoutParameters) { [weak self] result in
            switch result {
            case .success(let model):
                if model.paymentURL.isEmpty { /// cach
                    self?.coordinator?.navigateTo(MainDestination.checkoutSuccess(model))
                } else { /// knet
                    self?.coordinator?.navigateTo(MainDestination.payment(model))
                }
            case .failure(let error):
                self?.requestError?.value = error
            }
        }
    }
    
    fileprivate func isCheckoutValid() -> Bool {
        guard checkoutParameters.paymentMethod != nil else {
            requestError?.value = .messageError(R.string.localizable.pleaseSelectPaymentMethod())
            return false
        }
        guard !isCheckoutAsGuest else { return true }
        guard !addresses.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseAddAnAddress())
            return false
        }
        guard checkoutParameters.addressID != 0 else {
            requestError?.value = .messageError(R.string.localizable.pleaseSelectYourAddress())
            return false
        }
        return true
    }
    
    func applyCoupon() {
        guard isValidCoupon() else { return }
        guard coponCode != couponParams.code else {
            requestError?.value = .messageError(R.string.localizable.coponIsAlreadyUsed())
            return
        }
        self.coponCode = self.couponParams.code
        repo?.applyCoupon(couponParams) { [weak self] result in
            switch result {
            case .success(let model):
                guard let self = self else{return}
                self.coponData.value = model
                self.checkoutParameters.couponID = model.coponID.toString
                self.couponApplied.value = true
                self.cartModel?.total = String(format: "%.3f", Double(model.total))
                self.disCountValue = String(format: "%.3f", Double(model.discount))
            case .failure(let error):
                guard let self = self else{return}
                self.requestError?.value = error
                self.couponApplied.value = false
            }
        }
    }
    
    fileprivate func isValidCoupon() -> Bool {
        guard !couponParams.code.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterCouponCode())
            return false
        }
        return true
    }
    
    func addAddress() {
        coordinator?.navigateTo(MainDestination.addAddress(areas))
    }
}

// MARK: - ViewModel Protocols
protocol CheckoutVMProtocol: CheckoutFunctional {
    var numberOfAddresses: Int { get }
    var numberOfMethods: Int { get }
    var guestTotalAfterSelectAddress:Double {get}
    var guestDeliveryCharge:Double {get}
    var couponParams: CouponParameters! { get set }
    var productsTotal: String { get }
    var deliveryCharge: String { get }
    var discount: String { get }
    var total: String { get }
    var couponApplied: Observable<Bool> { get set }
    var isCheckoutAsGuest: Bool { get set }
    var guestAddressDescription: String { get }
}

protocol CheckoutFunctional: ViewModel {
    func onViewDidLoad()
    func methodForCell(at index: Int) -> SortTableViewCellViewModel
    func address(at index: Int) -> AddressModel
    func didSelectAddress(at index: Int)
    func didSelectMethod(at index: Int)
    func checkout()
    func applyCoupon()
    func addAddress()
    var guestAddressName:String {get}
    var coponCode: String {get set}
    var coponData: Observable<CouponModel> {get set}
}




struct CheckoutParameters: Parameters {
    var addressID: Int = 0
    var paymentMethod: PaymentMethod?
    var couponID: String = ""
 
    var address : AddressParameters?
    
    var body: [String: Any] {
   
        if CachingManager.shared.isLogin {
            return  ["address_id": addressID,
                     "payment_method": paymentMethod ?? .online,
                     "execute": 1,
                     "copon_id": couponID]
        }else{
            return ["payment_method": paymentMethod ?? .online,
                    "execute": 1,
                    "copon_id": couponID,
                    "area_id":address?.area_ID ?? 0,
                    "mobile":address?.mobile ?? "",
                    "email":address?.email ?? "",
                    "address":address?.desc ?? "",
                    "username":address?.customerName ?? "",
            ]
        }
    }
}


