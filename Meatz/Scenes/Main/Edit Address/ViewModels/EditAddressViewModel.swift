//
//  EditAddressViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/14/21.
//

import Foundation

final class EditAddressViewModel{
    private var coordinator : Coordinator?
    private var repo :EditAddressRepoProtocol?
    private var parameters : AddressParameters = AddressParameters()
    private var areas : [AreaModel] = []
    var state: State = .notStarted
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable.init(nil)
    var areaName: Observable<String> = Observable.init("")
    var address : AddressModel!{
        didSet{
            parameters.address = address
        }
    }
    init(_ repo : EditAddressRepoProtocol?,_ coordinator : Coordinator?) {
        self.coordinator = coordinator
        self.repo = repo
    }
    
    func setAreas(_ areas :[AreaModel]){
        self.areas = areas
    }
}


extension EditAddressViewModel :EditAddressVMProtocol{
    
    func EditAddress() {
        guard isValid() else{return}
        repo?.editAddress(address.id,parameters, { [weak self](result) in
            guard let self = self else{return}
            switch result {
            case .success(let model):
                self.state = .success
                guard let completion = self.onRequestCompletion else { return }
                completion(model.message)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        })
    }
    func chooseArea() {
        coordinator?.present(MainDestination.areas(areas, {[weak self] city in
            self?.updateParameters(.area(city.id))
            self?.areaName.value = city.name
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
        default : break
        }
    }
    
    
    fileprivate func isValid() -> Bool {
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
    
    func back() {
        coordinator?.pop(true)
    }
}


protocol EditAddressVMProtocol : ViewModel{
    var address : AddressModel!{get set}
    var areaName : Observable<String>{get}
    func chooseArea()
    func EditAddress()
    func updateParameters(_ type : AddressFieldType)
    func back()
}
