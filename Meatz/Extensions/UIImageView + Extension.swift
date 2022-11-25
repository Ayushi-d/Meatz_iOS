//
//  UIImageView + Extension.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/24/21.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView{
    
    func loadImage(_ urlString : String,_ placeholder : UIImage = R.image.placeHolder()!){
        guard let url = URL(string: urlString) else{return}
//        sd_setImage(with: url, placeholderImage: , options: .waitStoreCache, context: [:])
        sd_setImage(with: url, placeholderImage: placeholder, options: SDWebImageOptions.refreshCached) { (image_, error, cachType,_) in            
        }
    }
}
