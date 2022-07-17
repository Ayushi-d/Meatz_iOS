//
//  UpdateCheckoutViewModel.swift
//  Meatz
//
//  Created by Mahmoud Khaled on 9/29/21.
//

import UIKit

class UpdateCheckoutViewModel: UpdateCheckoutVMProtocol {
    
    
    
    var state: State = .notStarted
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable(nil)
    
    var selectedDateISTody: Bool = false
    var showNormalView: Observable<Bool> = Observable(false)
    var showActivityIndicator: Observable<Bool> = Observable(false)
    var deliveryTypeItems: Observable<[DeliveryTypeBody]> = Observable([])
    var paymentMethodItems: Observable<[PaymentMethodBody]> = Observable([])
    var addresses: Observable<[AddressModel]> = Observable([])
    
    var dayes: Observable<[DayModel]> = Observable([])
    var periods: Observable<[PeriodModel]> = Observable([])
    
    var checkoutDetails: Observable<CehckoutDetailsModel> = Observable(CehckoutDetailsModel(nil))
    
    var unSelectDeliveryType: Observable<Int> = Observable(0)
    
    var selectedAddress: Observable<AddressModel>? = Observable(nil)
    
    private var areas: [AreaModel] = []
    
    
    var showExpressDeliveryView: Observable<Bool> = Observable(false)
    var isCheckoutAsGuest: Bool
    var guestAddress: AddressParameters?
    private var checkoutParameters: UpdateCheckoutParameters = UpdateCheckoutParameters()
    
    var couponApplied: Observable<Bool> = Observable(false)
    var coponData: Observable<CouponModel> = Observable(nil)
    var coponCode: String = ""
    var couponParams: CouponParameters!
    
    private var repo: CheckoutRepoProtocol?
    private var coordinator: Coordinator?
    
    private let dispatchGroup = DispatchGroup()
    
    init(_ repo: CheckoutRepoProtocol,_ coordinator: Coordinator?, _ isCheckoutAsGuest: Bool, guestAddress: AddressParameters?) {
        self.repo = repo
        self.guestAddress = guestAddress
        self.checkoutParameters.address = guestAddress
        self.isCheckoutAsGuest = isCheckoutAsGuest
        self.coordinator = coordinator
    }
    
    
     func viewDidLoad() {
        clearParameters()
        coponCode = ""
        showActivityIndicator.value = true
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        getAddresses()
        getCheckoutDetails()
        getAreas()
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            guard let completion = self.onRequestCompletion else { return }
            self.showActivityIndicator.value = false
            self.creatPaymentMethods()
            if !self.isCheckoutAsGuest {
                self.firstCreatDeliveryTypeForUser()
            }
            completion("")
        }
    }
    
    private func clearParameters() {
        checkoutParameters.addressID = 0
        checkoutParameters.couponID = ""
        checkoutParameters.deliveryDate = ""
        checkoutParameters.deliveryPeriodId = 0
        checkoutParameters.paymentMethod = ""
        checkoutParameters.deliveryType = ""
    }
    
    var numberOfAddresses: Int {
        return addresses.value?.count ?? 0
    }
    
    var numberOfDeliveryTypeItems: Int {
        return deliveryTypeItems.value?.count ?? 0
    }
    
    var numberOfPaymentMethods: Int {
        return paymentMethodItems.value?.count ?? 0
    }
    
    var numberOfDayesItems: Int {
        return dayes.value?.count ?? 0
    }
    
    var numberOfPeriodsItems: Int {
        return periods.value?.count ?? 0
    }
    
    private func creatPaymentMethods() {
        let items = [PaymentMethodBody(type: .online),
                     PaymentMethodBody(type: .wallet, walletV: checkoutDetails.value!.wallet, isSelectable: checkoutDetails.value!.wallet >= checkoutDetails.value!.total)]
        
        paymentMethodItems.value = items
    }
    
    func createDeliveryTypeForUser(index: Int) {
        let items = [DeliveryTypeBody(type: .normal, value: addresses.value?[index].area.delivery ?? 0.0),
                     DeliveryTypeBody(type: .express, value: addresses.value?[index].area.deliveryExpress ?? 0.0, isSelectable: checkoutDetails.value!.expressDelivery)
        ]
        
        deliveryTypeItems.value = items
        selectedAddress?.value = addresses.value![index]
        checkoutParameters.addressID = addresses.value![index].id
        
        checkoutDetails.value?.delivery = 0
        calculateTotalPrice()
        checkoutParameters.deliveryType = ""
    }
    
    private func firstCreatDeliveryTypeForUser() {
        let items = [DeliveryTypeBody(type: .normal, value: 0.0),
                     DeliveryTypeBody(type: .express, value: 0.0, isSelectable: checkoutDetails.value!.expressDelivery)
        ]
        deliveryTypeItems.value = items
    }
    
    func createDeliveryTypeForGuest() {
        let items = [DeliveryTypeBody(type: .normal, value: guestAddress?.deliveryCost ?? 0.0),
                     
                     DeliveryTypeBody(type: .express, value: guestAddress?.deliveryExpress ?? 0.0, isSelectable: checkoutDetails.value!.expressDelivery)
        ]
        
        deliveryTypeItems.value = items
        
    }
    
    func getDeliveryTypeModel(at index: Int) -> DeliveryTypeBody {
        return deliveryTypeItems.value![index]
    }
    
    func didSelectDeliveryType(at index: Int) {
        
        if isCheckoutAsGuest {
            handleSelectDeliveryType(at: index)
        } else {
            guard checkoutParameters.addressID != 0 else {
                unSelectDeliveryType.value = index
                requestError?.value = .messageError(R.string.localizable.pleaseSelectYourAddress())
                return
            }
            handleSelectDeliveryType(at: index)
        }
    }
    
    private func handleSelectDeliveryType(at index: Int) {
        checkoutParameters.deliveryType = deliveryTypeItems.value![index].type.rawValue
        
        showExpressDeliveryView.value =  deliveryTypeItems.value![index].type == .express ? true : false
        
        checkoutDetails.value!.delivery = deliveryTypeItems.value![index].value
        
        calculateTotalPrice()
        
        if checkoutParameters.paymentMethod == PaymentMethod.wallet.rawValue && checkoutDetails.value!.total > checkoutDetails.value!.wallet {
            creatPaymentMethods()
            checkoutParameters.paymentMethod.removeAll()
        }
        
        checkoutParameters.deliveryDate.removeAll()
        checkoutParameters.deliveryPeriodId = 0
    }
    
    func getPaymentMethodModel(at index: Int) -> PaymentMethodBody {
        return paymentMethodItems.value![index]
    }
    
    func didSelectPaymentMethod(at index: Int) {
        checkoutParameters.paymentMethod = paymentMethodItems.value![index].type.rawValue
    }
    
    func getDayesModel(at index: Int) -> DayModel {
        return dayes.value![index]
    }
    
    func didSelectDay(at index: Int) {
        selectedDateISTody = dayes.value![index].today
        periods.value = checkoutDetails.value?.periods
        checkoutParameters.deliveryDate = dayes.value![index].date
    }
    
    func getPeriodModel(at index: Int) -> PeriodModel {
        return periods.value![index]
    }
    
    func didSelectPeriod(at index: Int) {
        checkoutParameters.deliveryPeriodId = periods.value![index].id
    }
    
    private func calculateTotalPrice() {
        checkoutDetails.value!.total =  (checkoutDetails.value!.subtotal - checkoutDetails.value!.discount) + checkoutDetails.value!.delivery
    }
    
    func addAddress() {
        coordinator?.navigateTo(MainDestination.addAddress(areas))
    }
    
    fileprivate func isCheckoutValid() -> Bool {
        
        if !isCheckoutAsGuest {
            
            guard !addresses.value!.isEmpty else {
                requestError?.value = .messageError(R.string.localizable.pleaseAddAnAddress())
                return false
            }
            
            guard checkoutParameters.addressID != 0  else {
                requestError?.value = .messageError(R.string.localizable.pleaseSelectYourAddress())
                return false
            }
        }
        
        guard !checkoutParameters.paymentMethod.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseSelectPaymentMethod())
            return false
        }
        
        guard !checkoutParameters.deliveryType.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseSelectDeliveryType())
            return false
        }
        
        if checkoutParameters.deliveryType == DeliveryType.normal.rawValue  {
            guard !checkoutParameters.deliveryDate.isEmpty else {
                requestError?.value = .messageError(R.string.localizable.pleaseSelectOrderDate())
                return false
            }
            
            guard checkoutParameters.deliveryPeriodId != 0 else {
                requestError?.value = .messageError(R.string.localizable.pleaseSelectOrderTime())
                return false
            }
        }
        
        return true
    }
    
    fileprivate func isValidCoupon() -> Bool {
        guard !couponParams.code.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterCouponCode())
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
        showActivityIndicator.value = true
        couponParams.total = self.checkoutDetails.value!.subtotal.toString
        repo?.applyCoupon(couponParams) { [weak self] result in
            guard let self = self else { return }
            self.showActivityIndicator.value = false
            switch result {
            case .success(let model):
                self.coponData.value = model
                self.checkoutParameters.couponID = model.coponID.toString
                self.couponApplied.value = true
                self.checkoutDetails.value!.discount = model.discount
                self.calculateTotalPrice()
            case .failure(let error):
                self.requestError?.value = error
                self.couponApplied.value = false
            }
        }
    }
    
    func checkout() {
        guard isCheckoutValid() else { return }
        showActivityIndicator.value = true
        repo?.checkout(checkoutParameters) { [weak self] result in
            guard let self = self else { return }
            self.showActivityIndicator.value = false
            switch result {
            case .success(let model):
                if model.paymentURL.isEmpty { /// cach
                    self.coordinator?.navigateTo(MainDestination.checkoutSuccess(model))
                } else { /// wallet
                    self.coordinator?.navigateTo(MainDestination.payment(model))
                }
            case .failure(let error):
                self.requestError?.value = error
            }
        }
    }
    

    func getAddresses() {
        guard !isCheckoutAsGuest else {
            dispatchGroup.leave()
            return
        }
            repo?.getAddresses { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model):
                    self.addresses.value = model.addresses
                    self.dispatchGroup.leave()
                    self.createDeliveryTypeItems()
                case .failure(let error):
                    self.requestError?.value = error
                    self.dispatchGroup.leave()
                }
            }
    }
    
    private func createDeliveryTypeItems() {
        deliveryTypeItems.value =  [DeliveryTypeBody(type: .normal, value: 0),
            DeliveryTypeBody(type: .express, value: 0)]
    }
    
    func getCheckoutDetails() {
        
        repo?.getCheckoutDetails({ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.checkoutDetails.value = response
                self.calculateTotalPrice()
                self.dayes.value = response.dates.days
                self.couponParams = CouponParameters(total: self.checkoutDetails.value!.total.toString)
                self.dispatchGroup.leave()
            case .failure(let error):
                self.requestError?.value = error
                self.dispatchGroup.leave()
            }
        })
    }
    
    func getAreas() {
        repo?.getAreas { [weak self] result in
            guard let self  = self else { return }
            switch result {
            case .success(let model):
                self.areas = model.areas
                self.dispatchGroup.leave()
            case .failure(let error):
                self.requestError?.value = error
                self.dispatchGroup.leave()
            }
        }
    }
    
}



protocol UpdateCheckoutVMProtocol: ViewModel {
    
    var showActivityIndicator: Observable<Bool> { get set }
    var addresses: Observable<[AddressModel]> { get set }
    var guestAddress: AddressParameters? { get set }
    var isCheckoutAsGuest: Bool { get set }
    var selectedDateISTody: Bool { get set }
    var couponParams: CouponParameters! { get set }
    var showExpressDeliveryView: Observable<Bool> { get set }
    var showNormalView: Observable<Bool> { get set }
    var deliveryTypeItems: Observable<[DeliveryTypeBody]> { get set }
    var checkoutDetails: Observable<CehckoutDetailsModel> { get set }
    var paymentMethodItems: Observable<[PaymentMethodBody]> { get set }
    var selectedAddress: Observable<AddressModel>? { get set }
    var dayes: Observable<[DayModel]> { get set }
    var periods: Observable<[PeriodModel]> { get set }
    var couponApplied: Observable<Bool> { get set }
    var coponData: Observable<CouponModel> {get set }
    var unSelectDeliveryType: Observable<Int> { get set}
    var numberOfAddresses: Int { get }
    var numberOfDeliveryTypeItems: Int { get }
    var numberOfPaymentMethods: Int { get }
    
    var numberOfDayesItems: Int { get }
    var numberOfPeriodsItems: Int { get }
    
    func viewDidLoad()
    func applyCoupon()
    func createDeliveryTypeForGuest()
    func createDeliveryTypeForUser(index: Int)
    
    func getDeliveryTypeModel(at index: Int) -> DeliveryTypeBody
    func didSelectDeliveryType(at index: Int)
    func getPaymentMethodModel(at index: Int) -> PaymentMethodBody
    func didSelectPaymentMethod(at index: Int)
    
    func getDayesModel(at index: Int) -> DayModel
    func getPeriodModel(at index: Int) -> PeriodModel
    
    func didSelectDay(at index: Int)
    func didSelectPeriod(at index: Int)
    
    func addAddress()
    func checkout()
}

struct DeliveryTypeBody: SelectionTypeProtocol {
    
    var type: DeliveryType = .normal
    var value: Double = 0.0
    var isSelectable: Bool = true
    
    var title: String {
        return type.title
    }
    
    var titleValue: String {
        if value == 0 {
            return ""
        } else {
            return "\(value.toString.convertToKwdFormat()) \(R.string.localizable.kwd())"
        }
        
    }
        
    var isValiable: Bool {
        return isSelectable
    }
    
}

struct PaymentMethodBody: SelectionTypeProtocol {
    
    var type: PaymentMethod = .online
    var walletV: Double = 0.0
    var isSelectable: Bool = true
    
    var title: String {
        return type.titleString
    }
    
    var walletValue: String {
        
        return type == .wallet ? "\(walletV.toString.convertToKwdFormat()) \(R.string.localizable.kwd()) " :  ""
    }
    
        
    var isValiable: Bool {
        return isSelectable
    }
    
}


enum DeliveryType: String  {
    case normal = "usual"
    case express = "express"
    
    var title: String {
        switch self {
        case .express: return R.string.localizable.express()
        case .normal: return R.string.localizable.normal()
        }
    }
}

enum PaymentMethod: String, SortTableViewCellViewModel {
    case online = "knet"
    case wallet = "wallet"
    
    var titleString: String {
        switch self {
        case .online: return R.string.localizable.online()
        case .wallet: return R.string.localizable.wallet()
        }
    }
}



protocol SelectionTypeProtocol {
    var title: String { get }
    var titleValue: String { get }
    var walletValue: String { get }
    var isValiable: Bool  { get }
}

extension SelectionTypeProtocol {
    var titleValue: String {return ""}
    var walletValue: String { return ""}
}

struct UpdateCheckoutParameters: Parameters {
    var addressID: Int = 0
    var paymentMethod: String = ""
    var couponID: String = ""
    var deliveryType: String = ""
    var deliveryDate: String = ""
    var deliveryPeriodId: Int = 0
 
    var address : AddressParameters?
    
    var body: [String: Any] {
   
        if CachingManager.shared.isLogin {
            return  ["address_id": addressID,
                     "payment_method": paymentMethod,
                     "execute": 1,
                     "copon_id": couponID,
                     "delivery_type": deliveryType,
                     "delivery_date": deliveryDate,
                     "delivery_period_id": deliveryPeriodId]
        }else{
            return ["payment_method": paymentMethod,
                    "execute": 1,
                    "copon_id": couponID,
                    "area_id":address?.area_ID ?? 0,
                    "mobile":address?.mobile ?? "",
                    "email":address?.email ?? "",
                    "address":address?.descAddressForGuest ?? "",
                    "username":address?.customerName ?? "",
                    "delivery_type": deliveryType,
                    "delivery_date": deliveryDate,
                    "delivery_period_id": deliveryPeriodId]
        }
    }
}


// MARK: - Parameters
struct CouponParameters: Parameters {
    var code: String = ""
    var total: String
    var body: [String: Any] {
        return ["code": code,
                "total": total]
    }
}

