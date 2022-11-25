//
//  AddBoxViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/15/21.
//

import Foundation

final class AddBoxViewModel {
    private var repo: AddBoxRepoProtocol?
    private var coordinator: Coordinator?
    var onRequestCompletion: ((_ message: String?) -> Void)?
    var state: State = .notStarted
    var requestError: Observable<ResultError>? = Observable(nil)
    var parameters = addBoxRepoParams()
    init(_ repo: AddBoxRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension AddBoxViewModel: AddBoxVMProtocol {
    func addBox(_ boxName:String) {
        parameters.name = boxName
        
        guard !parameters.name.isEmpty else {
            requestError?.value = .messageError(R.string.localizable.pleaseEnterBoxName())
            return
        }
        
        repo?.addBox(parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let completion = self.onRequestCompletion else { return }
                completion(data.message)
            case .failure(let error):
                self.requestError?.value = error
            }
        }
    }
    
    func popToBoxes() {
        coordinator?.navigateTo(MainDestination.pop)
    }
}

protocol AddBoxVMProtocol: ViewModel {
    func addBox(_ boxName:String)
    func popToBoxes()
}

struct addBoxRepoParams: Parameters {
    var name: String = ""
    var body: [String: Any] {
        return ["name": name]
    }
}
