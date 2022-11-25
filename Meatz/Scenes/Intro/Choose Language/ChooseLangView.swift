//
//  ChooseLangView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import UIKit

final class ChooseLangView: UIViewController {
    weak var coordinator : IntroCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


//MARK:- Actions
extension ChooseLangView {
    
    @IBAction private func arabicPressed(_ sender : UIButton){
        changeLanguageTo(.ar)
      
    }
    
    @IBAction private func englishPressed(_ sender : UIButton){
        changeLanguageTo(.en)
        
    }
    
    func changeLanguageTo(_ language: MOLHLanguages) {
        SHeaders.shared.updateLanguage(language.rawValue)
        MOLH.setLanguageTo(language)
        MOLH.reset()
        coordinator?.navigateTo(IntroDestination.ads)
    }
}
