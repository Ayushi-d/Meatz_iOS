//
//  SharedRefrencProtocol.swift
//  Jahrawy
//
//  Created by khaledkamal on 10/25/19.
//  Copyright © 2019 khaledkamal. All rights reserved.
//

import Foundation

public protocol SharedRefrencProtocol {
    func set(_ value: String?, forKey key: String)
    func get(forKey key: String) -> String?

    func setElement<T: Codable>(_ element: T, forKey key: String)
    func getElement<T: Codable>(forKey key: String) -> T?

    func delete(forKey key: String)
}
