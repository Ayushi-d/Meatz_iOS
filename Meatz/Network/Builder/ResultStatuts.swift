//
//  ResultStatuts.swift
//  Mandob
//
//  Created by khaledkamal on 7/29/18.
//  Copyright © 2018 khaledkamal. All rights reserved.
//

import Foundation

public enum ResultStatuts<T> {
    case success(T)
    case failure(ResultError)
}
