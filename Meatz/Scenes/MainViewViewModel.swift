//
//  MainViewViewModel.swift
//  Meatz
//
//  Created by Nabil Elsherbene on 4/22/21.
//

import Foundation

final class MainViewViewModel{
    private var coordinator: Coordinator?
    init(_ coordinator: Coordinator?) {
        self.coordinator = coordinator
    }
    
    func navigateToCart(){
        coordinator?.navigateTo(MainDestination.cart)
    }
    

}
