//
//  DeliveryAddressViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/25/21.
//

import Foundation


import Foundation

final class DeliveryAddressViewModel{
    private var coordinator : Coordinator?
    private var repo : MyAddressRepoProtocol?
    private var parameters : AddressParameters = AddressParameters()
    private var areas : [AreaModel] = []
    var state: State = .notStarted
    var cartModel : CartDataModel?
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable.init(nil)
    var areaName: Observable<String> = Observable.init("")
    
    init(_ repo : MyAddressRepoProtocol?,_ coordinator : Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
    
    func setAreas(_ areas :[AreaModel]){
        self.areas = areas
    }
}


extension DeliveryAddressViewModel :DeliveryAddressVMProtocol{
    
    func onViewDidLoad() {
        repo?.getAreas({ [weak self](result) in
            guard let self = self else{return}
            switch result{
            case .success(let model):
                self.areas = model.areas
                guard let completion = self.onRequestCompletion else{return}
                completion("")
            case .failure(let error):
                self.requestError?.value = error
            }
        })
    }
    func addAddress() {
        guard isValid() else{return}
        guard let cartModel_ = cartModel else{return}
        coordinator?.navigateTo(MainDestination.checkoutGuest(parameters,cartModel_))
    }
    
    func chooseArea() {
        coordinator?.present(MainDestination.areas(areas, {[weak self] city in
            self?.updateParameters(.area(city.id))
            self?.updateParameters(.areaName(city.name))
            self?.areaName.value = city.name
            self?.parameters.deliveryCost = city.delivery
            self?.parameters.deliveryExpress = city.deliveryExpress
            
        }))
    }
    func updateParameters(_ type: AddressFieldType) {
        switch type{
        case .addressName(let value):
            parameters.addressName = value
        case .area(let value):
            parameters.area_ID = value
        case .block(let value):
            parameters.block = value
        case .aptNum(let value):
            parameters.aptNum = value
        case .floorNo(let value):
            parameters.floorNo = value
        case .street(let value):
            parameters.street = value
        case .notes(let value):
            parameters.notes = value
        case .houseNumber(let value):
            parameters.houseNumber = value
        case .customerName(let value):
            parameters.customerName = value
        case .email(let value):
            parameters.email = value
        case .phone(let value ):
            parameters.mobile = value
        case .areaName(let name):
            parameters.areaName = name
        }
    }
    
    
    fileprivate func isValid() -> Bool {
        guard !parameters.customerName.isEmpty else{
            requestError?.value = .messageError(R.string.localizable.pleaseEnterCustomerName())
            return false
        }
        if !parameters.email.isEmpty {
            guard parameters.email.isValidEmail() else{
                requestError?.value = .messageError(R.string.localizable.pleaseEnterAValidEmail())
                return false
            }
        }
        
        guard !parameters.mobile.isEmpty else{
            requestError?.value = .messageError(R.string.localizable.pleaseEnterYourPhone())
            return false
        }
        
        guard parameters.mobile.count == 8 else{
            requestError?.value = .messageError(R.string.localizable.phoneLengthValidation())
            return false
        }
        
        guard !parameters.addressName.isEmpty else{
            requestError?.value = .messageError(R.string.localizable.pleaseEnterAddressName())
            return false
        }
        guard parameters.area_ID != 0 else{
            requestError?.value = .messageError(R.string.localizable.pleaseSelectArea())
            return false
        }
        guard !parameters.block.isEmpty else{
            requestError?.value = .messageError(R.string.localizable.pleaseEnterBlock())
            return false
        }
        guard !parameters.street.isEmpty else{
            requestError?.value = .messageError(R.string.localizable.pleaseEnterStreetNo())
            return false
        }
        guard !parameters.houseNumber.isEmpty else{
            requestError?.value = .messageError(R.string.localizable.pleaseEnterHouseNo())
            return false
        }
//        guard !parameters.aptNum.isEmpty else{
//            requestError?.value = .messageError(R.string.localizable.pleaseEnterFlatNo())
//            return false
//        }
//        guard !parameters.floorNo.isEmpty else{
//            requestError?.value = .messageError(R.string.localizable.pleaseEnterFloorNo())
//            return false
//        }
        return true
    }
}


protocol DeliveryAddressVMProtocol : ViewModel{
    var areaName : Observable<String>{get}
    func onViewDidLoad()
    func chooseArea()
    func addAddress()
    func updateParameters(_ type : AddressFieldType)
}

