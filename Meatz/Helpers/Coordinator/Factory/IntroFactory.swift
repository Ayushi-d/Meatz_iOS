//
//  IntroFactory.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import Foundation

protocol IntroFactoryProtocol {
    func ads() -> AdsView
    func langSelection() -> ChooseLangView
}


final class IntroFactory : IntroFactoryProtocol{
    private weak var coordinator : IntroCoordinator?
    init(_ coordinator : IntroCoordinator?) {
        self.coordinator = coordinator
    }
    func ads() -> AdsView {
        let vc = R.storyboard.intro.adsView()!
        vc.viewModel = AdsViewModel(AdsRepo(), coordinator)
        return vc
    }
    
    func langSelection() -> ChooseLangView {
        let vc = R.storyboard.intro.chooseLangView()!
        vc.coordinator = coordinator
        return vc
    }
}


//MARK:- Destinations 
enum IntroDestination : Destination{
    case ads
    case lang
}
