//
//  UICollectionView + Extension .swift
//  Asnan Tower
//
//  Created by Mohamed Zead on 3/10/21.
//  Copyright © 2021 Spark Cloud. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public static var identifier: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }

    public static var nib: UINib {
        return .init(nibName: identifier, bundle: nil)
    }
}


extension UICollectionView {

    func dequeue<Cell : UICollectionViewCell>(indexPath : IndexPath,type : Cell.Type)->Cell{
        return self.dequeueReusableCell(withReuseIdentifier:String(describing:  type), for: indexPath) as! Cell
    }

    func register<T : UICollectionViewCell>( type : T.Type){
        let nib = UINib(nibName: String(describing: type), bundle: nil)
        register(nib, forCellWithReuseIdentifier: String(describing: type))
    }
}
