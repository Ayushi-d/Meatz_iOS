//
//  ZSlider.swift
//  servants
//
//  Created by Mac on 3/20/20.
//  Copyright © 2020 spark. All rights reserved.
//

import UIKit

public class ZSlider: UIView {
    
    lazy var slider : ZSliderImageSliderView = {
        
        let layout = LayoutCollectionView()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let slider = ZSliderImageSliderView(frame: .zero, collectionViewLayout: layout)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
     var delegate: ZSliderDelegate?{
        didSet{
            slider.sliderDelegate = delegate
        }
    }
    
    
     var dataSource: ZSliderDataSource?{
        didSet{
            slider.sliderDataSource = dataSource
        }
    }
    
    public func reload(){
        slider.reloadData()
    }
    public func selectItemAt(index: Int){
        let indexPath = IndexPath(item: index, section: 0)
        slider.performBatchUpdates({[weak self] in
            self?.slider.scrollToItem(at: indexPath, at: .left, animated: true)
        })
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        addSubview(slider)
        setSliderConstraints()
        setSliderConfigs()
    }
    
    private func setSliderConfigs(){
        slider.isPagingEnabled = true
        slider.showsHorizontalScrollIndicator = false
    }
    
    private func setSliderConstraints(){
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: topAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    
}


