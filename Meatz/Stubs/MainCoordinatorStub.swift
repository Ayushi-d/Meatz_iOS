//
//  MainCoordinatorStub.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import Foundation
import UIKit

final class MainCoordinatorStub : Coordinator{
    var parent: Coordinator?
    var currentlyPresentedDestination : MainDestination?
    var currentlyNavigatedDestination : MainDestination?
    var navigationController: UINavigationController
    
    init(_ navigation : UINavigationController) {
        self.navigationController = navigation
    }
    func start() {
        print("Coordinator just started ...")
    }
    
    func popTo(_ destination: Destination, _ animated: Bool) {
        self.currentlyPresentedDestination = destination as! MainDestination
    }
    
    func present(_ destination: Destination) {
        self.currentlyPresentedDestination = destination as! MainDestination
    }
    
    func navigateTo(_ destination: Destination) {
        self.currentlyNavigatedDestination = destination as! MainDestination
    }
    
    func popToViewController(_ controller: Destination, _ animated: Bool) {
        //
    }
}
