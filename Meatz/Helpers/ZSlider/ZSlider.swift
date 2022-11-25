//
//  ZSlider.swift
//  servants
//
//  Created by Mac on 3/20/20.
//  Copyright © 2020 spark. All rights reserved.
//

import UIKit

public class ZSlider: UIView {
    
    var carousalTimer: Timer?
    var newOffsetX: CGFloat = 0.0
    
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
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = slider as? ZSliderImageSliderView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < (slider.sliderDataSource?.imagesFor(slider).count ?? 0) - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
    }
           
    
    func startTimer() {
        
            carousalTimer = Timer(fire: Date(), interval: 0.0015, repeats: true) { (timer) in

                let initailPoint = CGPoint(x: self.newOffsetX,y :0)

                if __CGPointEqualToPoint(initailPoint, self.slider.contentOffset) {

                    if self.newOffsetX < self.slider.contentSize.width {
                        self.newOffsetX += 0.25
                    }
                    if self.newOffsetX > self.slider.contentSize.width - self.slider.frame.size.width {
                        self.newOffsetX = 0
                    }

                    self.slider.contentOffset = CGPoint(x: self.newOffsetX,y :0)

                } else {
                    self.newOffsetX = self.slider.contentOffset.x
                }
            }

            RunLoop.current.add(carousalTimer!, forMode: .common)
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


