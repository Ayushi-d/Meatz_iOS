//
//  DescriptiveView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/21/21.
//

import Foundation
import UIKit

/// a Descriptive view to show image and a given message
final class DescriptiveView : UIView {
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var messageLabel : BaseLabel = {
        let label = BaseLabel()
        label.font = FontsType.medium.getFontWithSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alignmentEnabled = false
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(messageLabel)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setUpConstraints(){
//        NSLayoutConstraint.activate([
           // imageView.widthAnchor.constraint(equalToConstant: 50),
            //imageView.heightAnchor.constraint(equalToConstant: 50),
            //imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50).isActive = true
            /// label constraints
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
//        ])
    }
}
