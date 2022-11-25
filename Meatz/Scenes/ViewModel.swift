//
//  ViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/28/21.
//

import Foundation

protocol ViewModel {
    var state: State{ get set }
    var onRequestCompletion: ((_ message : String?) -> Void)? { get set }
    var requestError : Observable<ResultError>?{get set}
}

enum State{
    case notStarted
    case loading
    case finishWithError(ResultError)
    case success
}

extension State : Equatable{
    static func == (lhs: State, rhs: State) -> Bool {
        switch (lhs,rhs){
        case (.finishWithError(let lError),.finishWithError(let rError)):
            return lError.describtionError == rError.describtionError
        case (.loading,.loading):
            return true
        case (.notStarted,.notStarted):
            return true
        case (.success,.success):
            return true
        default:
            return false
        }
    }
    
    
}
