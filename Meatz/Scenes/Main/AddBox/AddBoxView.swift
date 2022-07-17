//
//  AddBoxView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/14/21.
//

import UIKit

final class AddBoxView: MainView {
    var viewModel: AddBoxVMProtocol?
    
    @IBOutlet weak var boxNameTF: BaseTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems(cartEnabled: false)
        onCompletion()
        onError()
    }

    fileprivate func onError() {
        viewModel?.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.showToast("", error?.describtionError ?? "", completion: nil)
        }
    }

    fileprivate func onCompletion() {
        viewModel?.onRequestCompletion = { [weak self] message in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.showToast("", message ?? "") {
                self.viewModel?.popToBoxes()
            }
        }
    }

    @IBAction func createNewBox(_ sender: Any) {
        showActivityIndicator()
        viewModel?.addBox(boxNameTF.text ?? "")
    }
}
