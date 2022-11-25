//
//  ChangeLangController.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/18/21.
//

import UIKit

enum LanguageType: Int {
    case en = 0
    case ar = 1
    var value: Int {return rawValue}
}

final class ChangeLangController: UIViewController {

    weak var coordinator: Coordinator?
    
    @IBOutlet weak var enTitle: MediumLabel!
    @IBOutlet weak var arTitle: MediumLabel!
    @IBOutlet weak var enSelection: UIImageView!
    @IBOutlet weak var arSelection: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if MOLHLanguage.isArabic() {
            updateUIAccordingToCureentLang(.ar)

        } else {
            updateUIAccordingToCureentLang(.en)
        }
    }

    private func updateUIAccordingToCureentLang(_ language: MOLHLanguages) {
        if language == .en {
            enTitle.textColor = R.color.meatzRed()
            enSelection.image = #imageLiteral(resourceName: "selectRadio")
            arTitle.textColor = R.color.meatzBlack()
            arSelection.image = #imageLiteral(resourceName: "unchecked")

        } else {
            arTitle.textColor = R.color.meatzRed()
            arSelection.image = #imageLiteral(resourceName: "selectRadio")
            enTitle.textColor = R.color.meatzBlack()
            enSelection.image = #imageLiteral(resourceName: "unchecked")
        }
    }

    @IBAction func changeLangButtons(_ sender: UIButton) {
        switch sender.tag {
        case LanguageType.en.value:
            guard MOLHLanguage.isArabic() else { return }
            changeLanguageTo(.en)
        case LanguageType.ar.value:
            guard !MOLHLanguage.isArabic() else { return }
            changeLanguageTo(.ar)
        default: break
        }
    }
    
    func changeLanguageTo(_ language: MOLHLanguages) {
        SHeaders.shared.updateLanguage(language.rawValue)
        MOLH.setLanguageTo(language)
        MOLH.reset()
        let navigationVC = MainNavigationController()
        let mainCrd = MainCoordinator(navigationVC)
        mainCrd.start()
        mainCrd.parent = mainCrd
        appWindow?.rootViewController = navigationVC
    }

    @IBAction func dimissPopupAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
