//
//  TermsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/29/21.
//

import Foundation

final class TermsViewModel {
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable(nil)
    var state: State = .notStarted
    private var repo: TermsRepoProtocol?
    private var coordinator: Coordinator?
    private var model: TermsModel?

    init(_ repo: TermsRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension TermsViewModel: TermsVMProtocol {
    var title: String {
        return model?.title ?? ""
    }

    var content: String {
        return model?.content ?? ""
    }

    func onViewDidLoad() {
        repo?.getTerms { [weak self] result in
            switch result {
            case .success(let model):
                self?.model = model
                guard let completion = self?.onRequestCompletion else { return }
                completion("")
            case .failure(let error):
                self?.requestError?.value = error
            }
        }
    }
}

protocol TermsVMProtocol: ViewModel {
    var title: String { get }
    var content: String { get }

    func onViewDidLoad()
}
