//
//  ShopCategoryItem.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/28/21.
//

import Foundation
import UIKit

struct ShopCategoryItem  : CategoryViewModel{
    let id : Int
    let name : String
    let image: UIImage
    let selectedImage : UIImage
    var selected : Bool = false
    
    var ID: Int{
        return id
    }
    var categoryName: String{
        return name
    }
    
    var categoryImage: UIImage{
        return image
    }
    
    var categorySelectedImage : UIImage{
        return selectedImage
    }
    
    var isSelected: Bool{
        return selected
    }
}

protocol CategoryViewModel{
    var ID : Int{get}
    var categoryName : String{get}
    var categoryImage : UIImage{get}
    var categorySelectedImage : UIImage{get}
    var isSelected : Bool {get}
}
