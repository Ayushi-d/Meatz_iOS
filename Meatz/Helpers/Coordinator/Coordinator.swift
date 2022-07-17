//
//  Coordinator.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import Foundation
import UIKit

protocol Coordinator : Navigator{
    var parent : Coordinator?{get set}
    var navigationController : UINavigationController{get set}
    func start()
}

protocol Navigator : class{
    func present(_ destination: Destination)
    func navigateTo(_ destination : Destination)
    func pop(_ animated: Bool)
    func dismiss(_ animated : Bool,_ completion : (()->Void)?)
}
extension Navigator where Self : Coordinator{
    func pop(_ animated: Bool){
        navigationController.popViewController(animated: animated)
    }
   
    func dismiss(_ animated : Bool,_ completion : (()->Void)?){
        if let presentingViewController = navigationController.presentedViewController{
            presentingViewController.dismiss(animated: animated, completion: completion)
        }
    }
}


protocol Destination {}
