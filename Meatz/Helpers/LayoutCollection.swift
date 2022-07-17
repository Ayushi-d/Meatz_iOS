
import Foundation
import UIKit

class LayoutCollectionView: UICollectionViewFlowLayout {
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return MOLHLanguage.isArabic()
    }
}

