//
//  ZSliderImageSliderCell.swift
//  servants
//
//  Created by Mac on 3/20/20.
//  Copyright © 2020 spark. All rights reserved.
//

import Foundation
import UIKit



public class ZSliderImageSliderCell : UICollectionViewCell{
    
    lazy var cellImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        addSubview(cellImage)
        setImageConstraints()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cellImage)
        setImageConstraints()
    }
    
    
    private func setImageConstraints(){
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: topAnchor),
            cellImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
