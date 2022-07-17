//
//  DescriptiveViewBuilder.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/21/21.
//

import Foundation
import UIKit

final class DescriptiveViewBuilder{
    
    private var view : DescriptiveView
    
    init() {
        view = DescriptiveView()
    }
    
    func message(_ text : String) -> DescriptiveViewBuilder{
        view.messageLabel.text = text
        return self
    }
    
    func image(_ image: UIImage) -> DescriptiveViewBuilder{
        view.imageView.image = image
        return self
    }
    
    func build() -> DescriptiveView{
        return view
    }
}
