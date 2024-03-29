//
//  ShopViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/28/21.
//

import Foundation

protocol Listable{
    var itemID : Int{get}
    var itemName : String {get}
    var imageLink : String{get}
    var bannerLink: String{get}
    var type : ItemType{get}
    var cost : String{get}
    var costBefore: String{get}
    var navigationType : AdType{get}
    var rating: String{get}
    var tags: [TagModel] {get}
    
}
extension Listable{
    
    var itemID : Int{
        return 0
    }
    
    var type : ItemType{
        return .product
    }
    
    var cost : String{
        return ""
    }
    
    var costBefore: String{
        return ""
    }
    
    var navigationType : AdType{
        return .none
    }
    
    var rating: String{
        return ""
    }

    var tags : [TagModel]{
        return []
    }
}

enum ItemType{
    case sliderItem
    case product
    case specialOffer
}
