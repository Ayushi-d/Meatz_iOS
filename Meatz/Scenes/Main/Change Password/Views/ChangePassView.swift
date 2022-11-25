//
//  ChangePassView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/12/21.
//

import UIKit

final class ChangePassView: MainView {
    @IBOutlet private var confirmPassTextField: BaseTextField?
    @IBOutlet private var newPassTextField: BaseTextField?
    @IBOutlet private var oldPassTextField: BaseTextField?
    
    var viewModel: ChangePassVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems(cartEnabled: false)
        onError()
        onCompletion()
        observeInput()
    }
    
    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.hideActivityIndicator()
            self.showToast("", err.describtionError, completion: nil)
        }
    }
    
    fileprivate func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] message in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.viewModel.presentSuccessAlert()
            
        }
    }
    
    fileprivate func observeInput() {
        oldPassTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParams(.oldPass(text ?? ""))
        }
        
        newPassTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParams(.newPass(text ?? ""))
        }
        
        confirmPassTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParams(.confirmPass(text ?? ""))
        }
    }
}

// MARK: - Actions

extension ChangePassView {
    @IBAction func changePass(_ sender: UIButton) {
        showActivityIndicator()
        viewModel.changePass()
    }
}
