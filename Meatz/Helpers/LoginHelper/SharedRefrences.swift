//
//  JHSharedRefrences.swift
//  Jahrawy
//
//  Created by khaledkamal on 10/25/19.
//  Copyright © 2019 khaledkamal. All rights reserved.
//

import Foundation

public class SharedRefrences {
    public static let shared = SharedRefrences()
    private let keychain = KeychainSwift()
    private init() {}
}

extension SharedRefrences: SharedRefrencProtocol {
    public func set(_ value: String?, forKey key: String) {
        guard let value_ = value else {
            keychain.delete(key)
            return
        }
        keychain.set(value_, forKey: key)
    }

    public func get(forKey key: String) -> String? {
        return keychain.get(key)
    }

    public func setElement<T: Codable>(_ element: T, forKey key: String) {
        keychain.setElement(element, forKey: key)
    }

    public func getElement<T: Codable>(forKey key: String) -> T? {
        return keychain.getElement(key)
    }

    public func delete(forKey key: String) {
        keychain.delete(key)
    }
}
