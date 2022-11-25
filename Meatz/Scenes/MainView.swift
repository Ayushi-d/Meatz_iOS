//
//  MainView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import Foundation
import UIKit
import Alamofire

class MainView: UIViewController {
    
    let badgeSize: CGFloat = 16
    let badgeTag = 9830384
    
    let carttButton = UIBarButtonItem()

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
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.cart()?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        button.addTarget(self, action: #selector(cartPressed), for: .touchUpInside)
       // let button = UIButton(image: R.image.cart()?.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(cartPressed))
        return button
    }()
    
    lazy var homeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: R.image.homeIcon()?.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(homePressed))
        return button
    }()
    
    
    var mainViewModel: MainViewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carttButton.customView = cartButton
        setNavigationItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCartCount()
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
    
    func badgeLabel(withCount count: Int) -> UILabel {
        let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
        badgeCount.translatesAutoresizingMaskIntoConstraints = false
        badgeCount.tag = badgeTag
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(10)
        badgeCount.backgroundColor = UIColor(named: "Maetz-Light-Red")
        badgeCount.text = String(count)
        return badgeCount
    }
    
    func showBadge(withCount count: Int) {
        let badge = badgeLabel(withCount: count)
        cartButton.addSubview(badge)
        //cartButton.addSubview(badge)

        NSLayoutConstraint.activate([
            badge.leftAnchor.constraint(equalTo: cartButton.leftAnchor, constant: 14),
            badge.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: 0),
            badge.widthAnchor.constraint(equalToConstant: badgeSize),
            badge.heightAnchor.constraint(equalToConstant: badgeSize)
        ])
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
            tabBarController?.navigationItem.rightBarButtonItem = carttButton
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
        navigationItem.rightBarButtonItem = carttButton
    }
}

extension MainView{
    
    
    func getCartCount(){
        AF.request("http://meatz-app.com/api/cart-count",method: .get, encoding: JSONEncoding.default, headers: SHeaders.shared.headers).responseJSON { response in
            switch(response.result)
            {
            case.success(let json):
                do {
                    print("success===",json)
                    let statusCode = response.response?.statusCode
                    let response = json as! NSDictionary
                    if(statusCode == 200)
                    {
                        print(response)
                        let data = response.object(forKey: "data") as! NSDictionary
                        guard let cartCount = data.object(forKey: "cart_count") as? Int else{
                            return
                        }
                        self.showBadge(withCount: cartCount)
                    }else{
//                        let message = response.object(forKey: "error") as! String
//                        print(message)
                    }
                }
            case .failure(let error):
                print("not sucess",error)
            }
        }
    }
    
    
}
