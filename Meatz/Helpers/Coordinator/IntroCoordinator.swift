//
//  IntroCoordinator.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import Foundation
import UIKit

final class IntroCoordinator : Coordinator{
    typealias dest = IntroDestination
    weak var parent: Coordinator?
    private var factory : IntroFactoryProtocol!
    var navigationController: UINavigationController
    
    init(_ navigation : UINavigationController) {
        self.navigationController = navigation
        self.navigationController.isNavigationBarHidden = true
        factory = IntroFactory(self)
    }
    
    func start() {
        let isFirstTime = CachingManager.shared.isFirstTime
        navigationController.isNavigationBarHidden = true
        if isFirstTime{
            navigateTo(dest.lang)
        }else{
            navigateTo(dest.ads)
        }
    }
    
    deinit {
        print("intro coordinator is released ... ")
    }
}


extension IntroCoordinator {

    func present(_ destination: Destination) {
        
    }
    
    func navigateTo(_ destination: Destination) {
        switch destination{
        case dest.ads:
            navigationController.pushViewController(factory.ads(), animated: true)
        case dest.lang:
            navigationController.pushViewController(factory.langSelection(), animated: true)
        
        default:
            break
        }
    }
    
    func popToViewController(_ controller: Destination, _ animated: Bool) {
        //
    }
}



