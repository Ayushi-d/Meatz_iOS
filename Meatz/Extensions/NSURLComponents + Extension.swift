//
//  NSURLComponents + Extension.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/26/21.
//

import Foundation

extension NSURLComponents{
    
    func getParametersValueForKey(_ name:  String) -> String?{
        let items = queryItems?.filter({$0.name == name}) ?? []
        if items.isEmpty{
            return nil
        }else{
            return items.first?.value ?? ""
        }
    }
}
