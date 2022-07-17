//
//  MainCoordinator.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator {
//    var checkout:UpdateCheckoutViewController?
    typealias dest = MainDestination
    weak var parent: Coordinator?
    var factory: MainFactoryProtocol!
    var navigationController: UINavigationController

    init(_ navigation: UINavigationController) {
        self.navigationController = navigation
        navigationController.isNavigationBarHidden = false
        factory = MainFactory(self)
    }

    func start() {
        navigationController.isNavigationBarHidden = false
        let tabBarVC = factory.tabBar()
        navigationController.pushViewController(tabBarVC, animated: false)
    }
}

extension MainCoordinator {
    
    func present(_ destination: Destination) {
        switch destination {
        case dest.filterView(let options, let selectedOptions, let action):
            navigationController.present(factory.filterView(options: options, selectedOptions, action), animated: false)
        case dest.sort(let option, let action):
            navigationController.present(factory!.sortView(option, action), animated: false)
        case dest.areas(let areas, let action):
            navigationController.present(factory.areas(areas, action), animated: true, completion: nil)
        case dest.changeLang:
            navigationController.present(factory.changeLang(), animated: true)
        case dest.addToBoxesDialog(let action):
            navigationController.present(factory.addToBoxes(action), animated: false, completion: nil)
        case dest.cartGuestAlert(let cartInfo):
            navigationController.present(factory.cartGuestAlert(cartInfo), animated: false, completion: nil)
        case dest.EditProfileWithPhone(let model):
            navigationController.present(factory.editProfileWithPhone(model), animated: false, completion: nil)
        case dest.changePassAlert:
            navigationController.present(factory.changePassAlert(), animated: false, completion: nil)
            
        default:
            break
        }
    }

    func navigateTo(_ destination: Destination) {
        switch destination {
        case dest.tab:
            navigationController.pushViewController(factory.tabBar(), animated: true)
        case dest.profile:
            navigationController.pushViewController(factory.profile(), animated: true)
        case dest.shopDetails(let id):
            navigationController.tabBarController?.tabBar.isHidden = true
            navigationController.pushViewController(factory.shopDetails(id), animated: true)
        case dest.featured:
            navigationController.tabBarController?.tabBar.isHidden = true
            navigationController.pushViewController(factory.featured(), animated: true)
        case dest.category(let id):
            navigationController.tabBarController?.tabBar.isHidden = true
            navigationController.pushViewController(factory.category(id), animated: true)
        case dest.ourBoxes:
            navigationController.tabBarController?.tabBar.isHidden = true
            navigationController.pushViewController(factory.ourBoxes(), animated: true)
        case dest.box(let id):
            navigationController.pushViewController(factory.box(id), animated: true)
        case dest.search:
            navigationController.pushViewController(factory.search(), animated: true)
        case dest.searchResult(let tab, let model):
            navigationController.pushViewController(factory.searchResult(tab, model), animated: true)
        case dest.editProfile(let model):
            navigationController.tabBarController?.tabBar.isHidden = true
            navigationController.pushViewController(factory.editProfile(model), animated: true)
        case dest.changPass:
            navigationController.pushViewController(factory.changePass(), animated: true)
        case dest.whishlist:
            navigationController.tabBarController?.tabBar.isHidden = true
            navigationController.pushViewController(factory.whishlist(), animated: true)
        case dest.adddresses:
            navigationController.tabBarController?.tabBar.isHidden = true
            navigationController.pushViewController(factory.myAddresses(), animated: true)
        case dest.addAddress(let areas):
            navigationController.pushViewController(factory.addAddress(areas), animated: true)
        case dest.boxProducts(let id):
            navigationController.pushViewController(factory.boxProducts(boxId: id), animated: true)
        case dest.createBox:
            navigationController.pushViewController(factory.createBox(), animated: true)
        case dest.pop:
            navigationController.popViewController(animated: true)
      
        case dest.editAddress(let model, let areas):
            navigationController.pushViewController(factory.editAddress(model,areas), animated: true)
        case dest.orders(let flag):
            navigationController.tabBarController?.tabBar.isHidden = true
            navigationController.pushViewController(factory.orders(flag), animated: true)
        case dest.orderDetails(let id):
            navigationController.pushViewController(factory.orderDetails(id), animated: true)
        case dest.page(let id):
            navigationController.pushViewController(factory.page(id), animated: true)
        case dest.contactUs(let info):
            navigationController.pushViewController(factory.contactUs(info), animated: true)
        case dest.product(let id):
            navigationController.pushViewController(factory.productDetails(id), animated: true)
        case dest.notifications:
            navigationController.pushViewController(factory.notifications(), animated: true)
            
        case dest.offerDetails(let id):
            navigationController.pushViewController(factory.offersDetails(offerId: id), animated: true)
            
        case dest.cart:
           // self.cart = factory.cart()
            navigationController.pushViewController(factory.cart(), animated: true)
            
            
            
        case dest.checkout(let model):
//            self.checkout = factory.checkout(model)
            navigationController.pushViewController(factory.checkout(model), animated: true)
        case dest.deliveryAddress(let model):
            navigationController.pushViewController(factory.delivery(model), animated: true)
        case dest.checkoutGuest(let address, let cartModel):
            navigationController.pushViewController(factory.checkoutAsGuest(address, cartModel), animated: true)
        case dest.checkoutSuccess(let model):
            navigationController.isNavigationBarHidden = true
            navigationController.pushViewController(factory.checkoutSuccess(model), animated: true)
            
            
        case dest.checkoutError:
            navigationController.isNavigationBarHidden = true
            navigationController.pushViewController(factory.checkoutError(), animated: true)
            
            
        case dest.payment(let model):
            navigationController.pushViewController(factory.payment(model), animated: true)
            
            
            
        case dest.popToCheckout:
            //guard let checkout_ = self.checkout else {return}
            navigationController.popToRootViewController(animated: true)
            
        case dest.wallet:
            navigationController.isNavigationBarHidden = false
            navigationController.pushViewController(factory.wallet(), animated: true)
        
        case dest.successRechageWallet(let model):
            navigationController.isNavigationBarHidden = true
            navigationController.pushViewController(factory.successRecharge(model: model), animated: true)
            
        case dest.myWalletAgain:
            navigationController.isNavigationBarHidden = false
            navigationController.popTo(WalletView.self)
            
            
        case dest.errorRechargeWallet:
            navigationController.isNavigationBarHidden = true
            navigationController.pushViewController(factory.errorRecharge(), animated: true)
      
        default:
            break
        }
    }

}
