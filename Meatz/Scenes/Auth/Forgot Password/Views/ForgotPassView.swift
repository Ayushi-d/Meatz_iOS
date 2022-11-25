//
//  ForgotPassView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/11/21.
//

import UIKit

final class ForgotPassView: UIViewController {
    @IBOutlet private var emailTextField: BaseTextField?
    @IBOutlet weak var backButton: UIButton!
    
    var viewModel: ForgotPassVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = R.image.back()?.imageFlippedForRightToLeftLayoutDirection()
        backButton.setImage(image, for: .normal)
        onError()
        onCompletion()
    }

    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.hideActivityIndicator()
            self.showToast("", err.describtionError, completion: nil)
        }
    }

    fileprivate func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] messsge in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.showDialogue(R.string.localizable.passwordSent(),
                              messsge ?? "",
                              R.string.localizable.ok().uppercased()) { [weak self] in
                self?.viewModel.back()
            }
        }
    }
}

//MARK:- Actions
extension ForgotPassView {
    @IBAction func sendPass(_ sender: UIButton) {
        showActivityIndicator()
        viewModel.send(emailTextField?.text ?? "")
    }
    
    @IBAction func back(_ sender : UIButton){
        viewModel.back()
    }
}
