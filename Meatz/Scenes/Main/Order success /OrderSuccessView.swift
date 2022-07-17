//
//  OrderSuccessView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/26/21.
//

import UIKit

final class OrderSuccessView: UIViewController {
    
    @IBOutlet private weak var paymentTitleLabel: BaseLabel?
    @IBOutlet private weak var transactionIDTitleLabel: BaseLabel?
    @IBOutlet private weak var paymentIDLabel: MediumLabel?
    @IBOutlet private weak var transactionIDLabel: MediumLabel?
    @IBOutlet private weak var orderIDLabel: MediumLabel?
    @IBOutlet private weak var homeBtn: BoldButton!
    
    var viewModel : OrderSuccessVMProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        if CachingManager.shared.isLogin{
            homeBtn.setTitle(R.string.localizable.myOrders(), for: .normal)
        }else {
            homeBtn.setTitle(R.string.localizable.home(), for: .normal)
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    fileprivate func loadData(){
        paymentIDLabel?.text = viewModel?.paymentID ?? ""
        transactionIDLabel?.text = viewModel?.transactionID ?? ""
        orderIDLabel?.text = viewModel?.orderID ?? ""
        transactionIDTitleLabel?.isHidden = viewModel!.isCash
        paymentTitleLabel?.isHidden = viewModel!.isCash
    }


    @IBAction func homeAction(_ sender : UIButton){
        if CachingManager.shared.isLogin {
            viewModel?.myOrders()
        }else{
            let navigationVC = MainNavigationController()
            let mainCrd = MainCoordinator(navigationVC)
            mainCrd.start()
            mainCrd.parent = mainCrd
            appWindow?.rootViewController = navigationVC
        }

    }
}
