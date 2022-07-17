//
//  AuthCoordinator.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/7/21.
//

import Foundation
import UIKit

final class AuthCoordinator : Coordinator{
    typealias dest = AuthDestination
    weak var parent: Coordinator?
    private var factory: AuthFactoryProtocol!
    var navigationController: UINavigationController
    
    init(_ navigation: UINavigationController) {
        self.navigationController = navigation
        self.navigationController.isNavigationBarHidden = true
        factory = AuthFactory(self)
    }
    
    func start() {
        navigateTo(dest.login)
    }
    
    deinit {
        navigationController.isNavigationBarHidden = false
        print("auth coordinator is released .. ")
    }
}

extension AuthCoordinator{
    
    func present(_ destination: Destination) {
        
    }
    
    func navigateTo(_ destination: Destination) {
        switch destination{
        case dest.login :
            navigationController.pushViewController(factory.login(), animated: true)
        case dest.register:
            navigationController.pushViewController(factory.register(), animated: true)
        case dest.forgetPass:
            navigationController.pushViewController(factory.forgetPass(), animated: true)
        case dest.terms:
            navigationController.pushViewController(factory.terms(), animated: true)
        default:
            break
        }
    }
    
    func popToViewController(_ controller: Destination, _ animated: Bool) {
        //
    }
}



enum AuthDestination : Destination {
    case login
    case forgetPass
    case register
    case terms
}
