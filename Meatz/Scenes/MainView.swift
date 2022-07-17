//
//  MainView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import Foundation
import UIKit

class MainView: UIViewController {

     lazy var titleLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = R.image.topLogo()
        return imageView
    }()
    
    private lazy var topLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = R.image.titleLogo()
        return imageView
    }()
    
    
    
    private lazy var notificationsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: R.image.bell(), style: .plain, target: self, action: #selector(notificationPressed))
        return button
    }()
    
    private lazy var cartButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: R.image.cart()?.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(cartPressed))
        return button
    }()
    
    lazy var homeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: R.image.homeIcon()?.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(homePressed))
        return button
    }()
    
    var mainViewModel: MainViewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItems()
    }
    
    @objc func cartPressed() {
        print("cart pressed ...")
        mainViewModel?.navigateToCart()
        
    }
    
    @objc func homePressed() {
        let navigationVC = MainNavigationController()
        let mainCrd = MainCoordinator(navigationVC)
        mainCrd.start()
        mainCrd.parent = mainCrd
        appWindow?.rootViewController = navigationVC
        
    }
    
    @objc func notificationPressed() {
        print("notification pressed ...")
    }
    
    
    ////usded for tabbarcontroller 
    func setNavigationItems(_ withCart: Bool = true) {
        NSLayoutConstraint.activate([
            titleLogo.widthAnchor.constraint(equalToConstant: 81),
            titleLogo.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        tabBarController?.navigationItem.titleView = titleLogo
        tabBarController?.navigationItem.leftBarButtonItem = notificationsButton
        if withCart{
            tabBarController?.navigationItem.rightBarButtonItem = cartButton
        }else {
            tabBarController?.navigationItem.rightBarButtonItem = nil
            }
        }

    
    func addLogoTitle() {
        NSLayoutConstraint.activate([
            titleLogo.widthAnchor.constraint(equalToConstant: 81),
            titleLogo.heightAnchor.constraint(equalToConstant: 22)
        ])
        navigationItem.titleView = titleLogo
    }
    
    ///used for viewController
    func addNavigationItems(cartEnabled : Bool = true){
        NSLayoutConstraint.activate([
            topLogo.widthAnchor.constraint(equalToConstant: 81),
            topLogo.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        navigationItem.titleView = titleLogo
        guard cartEnabled else{return}
        navigationItem.rightBarButtonItem = cartButton
    }
}
