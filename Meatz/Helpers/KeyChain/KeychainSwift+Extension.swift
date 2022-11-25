//
//  KeychainSwift+Extension.swift
//  GoldenBird
//
//  Created by khaledkamal on 12/20/18.
//  Copyright © 2018 khaledkamal. All rights reserved.
//

import UIKit

extension KeychainSwift {
    func setElement<T: Codable>(_ element: T, forKey key: String,
                                withAccess access: KeychainSwiftAccessOptions? = nil)
    {
        // Convert User To Data
        guard let data = try? JSONEncoder().encode(element) else {
            return
        }

        // Convert Data To String
        guard let valueS = String(data: data, encoding: String.Encoding.utf8) else {
            return
        }

        // Save-----------------------------------------------------------
        set(valueS, forKey: key, withAccess: access)
        // ---------------------------------------------------------------
    }

    func getElement<T: Codable>(_ key: String) -> T? {
        guard let valueS = KeychainSwift().get(key) else {
            return nil
        }
        guard let data = valueS.data(using: .utf8) else {
            return nil
        }

        guard let elemnt = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }

        return elemnt
    }
}
