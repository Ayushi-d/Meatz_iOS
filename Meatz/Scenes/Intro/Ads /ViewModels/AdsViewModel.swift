//
//  AdsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/31/21.
//

import Foundation

final class AdsViewModel {
    private var repo: AdsRepoProtocol?
    var coordinator: Coordinator?
    private var adsModel : AdsModel?
    var onRequestCompletion: ((_ message : String?) -> Void)? 
    var requestError: Observable<ResultError>?
    var state: State = .notStarted
    
    init(_ repo: AdsRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension AdsViewModel: AdsViewModelProtocol {
    var adLink: String{
        return adsModel?.image ?? "" 
    }
    func onViewDidLoad() {
        repo?.getAds { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.adsModel = model
                self.state = .success
                guard let completion = self.onRequestCompletion else{return}
                completion(nil)
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        }
    }
}

protocol AdsViewModelProtocol: ViewModel {
    var adLink : String{get}
    func onViewDidLoad()
}
