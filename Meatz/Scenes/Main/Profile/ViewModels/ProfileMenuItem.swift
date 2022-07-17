//
//  ProfileMenuItemViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/11/21.
//

import Foundation
import UIKit

struct ProfileMenuItem : ProfileMenuItemViewModel{
    let title : String
    let icon : UIImage
    var value: String = ""
    
    var name: String{
        return title
    }
    
    var image: UIImage{
        return icon
    }    
}


protocol ProfileMenuItemViewModel{
    var name : String{get}
    var image : UIImage{get}
    var value: String {get set }
}
