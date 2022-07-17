//
//  MyAddressViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/13/21.
//

import Foundation

final class MyAddressViewModel {
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable(nil)
    var state: State = .notStarted
    private var repo: MyAddressRepoProtocol?
    private var coordinator: Coordinator?
    private var addresses: [AddressModel] = []
    private var areas: [AreaModel] = []
    init(_ repo: MyAddressRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension MyAddressViewModel: MyAddressVMProtocol {
    var numberOfAddresses: Int {
        return addresses.count
    }
    
    var saveAddressesString: String {
        return numberOfAddresses.toString + " " + R.string.localizable.savedAddresses()
    }
    
    func onViewDidLoad() {
        repo?.getAddresses { [weak self] result in
            guard let self = self else { return }
            self.handle(result)
        }
        
        repo?.getAreas { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.areas = model.areas
            case .failure(let error):
                self.requestError?.value = error
            }
        }
    }
    
    fileprivate func handle(_ result: Result<MyAddressModel, ResultError>) {
        switch result {
        case .success(let model):
            self.state = .success
            self.addresses = model.addresses
            guard let completion = self.onRequestCompletion else { return }
            completion("")
        case .failure(let error):
            self.state = .finishWithError(error)
            self.requestError?.value = error
        }
    }
    
    func viewModelForAddress(at index: Int) -> MyAddressCellViewModel {
        return addresses[index]
    }
    
    func edit(_ vm: MyAddressCellViewModel) {
        guard let address = addresses.first(where: {$0.id == vm.ItemID}) else{return}
        coordinator?.navigateTo(MainDestination.editAddress(address, areas))
    }
    
    func addAddress() {
        coordinator?.navigateTo(MainDestination.addAddress(areas))
    }
    
    func didSelectAddress(at index: Int) {}
    
    func deleteAddress(with id: Int) {
        repo?.deleteAddress(with: id) { [weak self] result in
            guard let self = self else { return }
            self.handle(result)
        }
    }
}

protocol MyAddressVMProtocol: ViewModel {
    var numberOfAddresses: Int { get }
    var saveAddressesString: String { get }
    func onViewDidLoad()
    func viewModelForAddress(at index: Int) -> MyAddressCellViewModel
    func didSelectAddress(at index: Int)
    func edit(_ vm: MyAddressCellViewModel)
    func deleteAddress(with id: Int)
    func addAddress()
}
