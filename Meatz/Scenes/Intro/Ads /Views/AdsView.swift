//
//  AdsView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import UIKit

final class AdsView: UIViewController {
    var mainCoorinator : Coordinator?
    
    @IBOutlet private weak var adsImageView: UIImageView?
    var viewModel : AdsViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        onError()
        onCompletion()
        viewModel.onViewDidLoad()
        startShimmerAnimation()
    }
    
    fileprivate func onError(){
        viewModel.requestError?.binding = {[weak self] error in
            guard let self = self else{return}
            guard let err = error else{return}
            self.showError(err)
        }
    }
    
    fileprivate func onCompletion(){
        viewModel.onRequestCompletion = {[weak self] _ in
            guard let self = self else{return}
            self.adsImageView?.loadImage(self.viewModel.adLink)
            self.stopShimmerAnimation()
        }
    }
}

//MARK:- Actions
extension AdsView {
    
    @IBAction func skip(_ sender : UIButton){
        let navigationVC = MainNavigationController()
        
        if CachingManager.shared.isFirstTime{
            mainCoorinator = MainCoordinator(navigationVC)
            let authCoordinator = AuthCoordinator(navigationVC)
            authCoordinator.start()
            authCoordinator.parent = mainCoorinator
            appWindow?.rootViewController = navigationVC
            CachingManager.shared.configLangSelected()
        }else{
            
            let mainCrd = MainCoordinator(navigationVC)
            mainCrd.start()
            mainCrd.parent = (viewModel as? AdsViewModel)?.coordinator
            appWindow?.rootViewController = navigationVC
        }
        
    }
}
