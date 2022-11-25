//
//  OrderErrorView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/26/21.
//

import UIKit

final class OrderErrorView: UIViewController {

    @IBOutlet private weak var actionButton: BoldButton?
  
    var viewModel : OrderErrorVMProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        setActionTitle()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    fileprivate func setActionTitle(){
        let actionTitle = CachingManager.shared.isLogin ? R.string.localizable.myOrders() : R.string.localizable.tryAgain()
        actionButton?.setTitle(actionTitle, for: .normal)
    }

}

extension OrderErrorView{
    @IBAction func tryAgain(_ sender : UIButton){
            viewModel?.tryAgain()
        }
    }
