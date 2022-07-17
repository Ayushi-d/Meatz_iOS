//
//  PageViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import Foundation

final class PageViewModel {
    private var repo: PageRepoProtocol?
    private let id: Int
    var onRequestCompletion: ((PageModel?) -> Void)?
    var requestError: Observable<ResultError>? = Observable(nil)
    var state: State = .notStarted

    init(repo: PageRepoProtocol?, id: Int) {
        self.repo = repo
        self.id = id
    }
}
// MARK: - Request

extension PageViewModel {
    func viewDidLoad() {
        self.repo?.getPage(with: id) { [weak self] result in
            guard let self = self else { return }
            self.responseHandeler(result)
        }
    }
}

// MARK: - Handel Response

extension PageViewModel {
    private func responseHandeler(_ result: Result<PageModel?, ResultError>) {
        switch result {
        case .success(let model):
            guard let completion = self.onRequestCompletion else { return }
            completion(model)
        case .failure(let error):
            self.requestError?.value = error
        }
    }
}
// MARK: - VM Protocol

protocol PageVMProtocol: ViewModel {
    func viewDidLoad()
}
