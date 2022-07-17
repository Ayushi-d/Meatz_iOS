//
//  ZSliderImageSlider.swift
//  servants
//
//  Created by Mac on 3/20/20.
//  Copyright © 2020 spark. All rights reserved.
//

import Foundation
import UIKit


public class ZSliderImageSliderView : UICollectionView{
    
     public var sliderDelegate : ZSliderDelegate?
     public var sliderDataSource : ZSliderDataSource?
    
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        backgroundColor = .clear
        register(ZSliderImageSliderCell.self, forCellWithReuseIdentifier: "x")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setDetaultLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        isPagingEnabled = true
        collectionViewLayout = layout
    }
}



extension ZSliderImageSliderView : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderDataSource?.imagesFor(self).count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "x", for: indexPath) as! ZSliderImageSliderCell
        let item = sliderDataSource?.imagesFor(self)[indexPath.item]
        guard let type = item?.source else{return cell}
        if type == .url{
            cell.cellImage.loadImage(item?.urlString ?? "")
        }else{
            cell.cellImage.image = item?.image
        }
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        sliderDelegate?.didDisplayItem(self, At: indexPath.item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.width
        let h = collectionView.frame.height
        return CGSize(width: w, height: h)
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sliderDelegate?.didSelectItem(self, At: indexPath.item)
    }
    
}


