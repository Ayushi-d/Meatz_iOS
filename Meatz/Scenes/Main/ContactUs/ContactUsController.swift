//
//  ContactUsController.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import UIKit

final class ContactUsController: MainView {
    @IBOutlet weak var nameTF: BaseTextField!
    @IBOutlet weak var emailTF: BaseTextField!
    @IBOutlet weak var phoneTF: BaseTextField!
    @IBOutlet weak var messageTV: BaseTextView!
    
    var viewModel: ContactUsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems(cartEnabled: false)
        updateUI()
        onCompletion()
        onError()
        messageTV.placeholder = R.string.localizable.message()
    }
    
    @IBAction func redirectToWhatsappAction(_ sender: Any) {
        SocialApi.WhatsApp(viewModel.whatspp).openUrl()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        self.showActivityIndicator()
        viewModel.sendMessage()
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
            self.showDialogue(R.string.localizable.thanks(), R.string.localizable.thanksForYourMessageWeWillContactYouSoon(), R.string.localizable.ok().uppercased()) { [weak self] in
                guard let self = self else {return}
                self.viewModel.popToSetting()
            }
            self.hideActivityIndicator()
            self.setInputsEmpty()
        }
    }
    
    private func setInputsEmpty() {
        nameTF.text = ""
        emailTF.text = ""
        phoneTF.text = ""
        messageTV.text = ""
    }
}

// MARK: - Update UI

extension ContactUsController {
    private func updateUI() {
        messageTV.textColor = R.color.meatzBlack()
        nameTF?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel?.updateFields(.name(text))
        }
        emailTF?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel?.updateFields(.email(text))
        }
        phoneTF?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel?.updateFields(.phone(text))
        }
        messageTV?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel?.updateFields(.message(text))
        }
    }
}
