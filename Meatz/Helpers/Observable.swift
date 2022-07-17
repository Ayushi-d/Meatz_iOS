//
//  Observable.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import Foundation

final class Observable<T>{
    var value : T?{
        didSet{
            binding?(value)
        }
    }
    
    
    var binding : ((_ value : T?) -> Void)?
    
    
    init(_ value : T?) {
        self.value = value
    }
}
