//
//  MainDestination + Equatable.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/1/21.
//

import Foundation

extension MainDestination : Equatable{
    
    static func == (lhs: MainDestination, rhs: MainDestination) -> Bool {
        switch (lhs,rhs){
        case (.tab,.tab) , (.profile ,.profile):
            return true
        case (.shopDetails(let lID),.shopDetails(let rID)):
            return lID == rID
        case (.filterView(_),.filterView(_)):
            return true
        case (.sort(_),.sort(_)):
            return true
        case (.featured ,.featured):
            return true
        case (.category(_),.category(_)):
            return true
        case (.ourBoxes,.ourBoxes):
            return true
        case (.box(let lID),.box(let rID)):
            return lID == rID
        case (.product(let l),.product(let r)):
            return l == r
        case (.search ,.search):
            return true
        default :
            return false
        }
    }
}
