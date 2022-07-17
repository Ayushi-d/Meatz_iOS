//
//  EditProfileView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/11/21.
//

import UIKit

final class EditProfileView: MainView {
    @IBOutlet private var firstNameTextField: BaseTextField?
    @IBOutlet private var lastNameTextField: BaseTextField?
    @IBOutlet private var phoneNumberTextField: BaseTextField?
    @IBOutlet weak var phoneIcon: UIImageView!
    
    var viewModel: EditProfileVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneIcon.image = #imageLiteral(resourceName: "telephone").imageFlippedForRightToLeftLayoutDirection()
        addNavigationItems(cartEnabled: false)
        loadData()
        observeInput()
        onError()
        onCompletion()
    }

    
    fileprivate func loadData() {
        firstNameTextField?.text = CachingManager.shared.getUser()?.firstName
        viewModel.updateParams(.firstName(CachingManager.shared.getUser()?.firstName ?? ""))
        lastNameTextField?.text = CachingManager.shared.getUser()?.lastName
        viewModel.updateParams(.lastName(CachingManager.shared.getUser()?.lastName ?? ""))
        phoneNumberTextField?.text = CachingManager.shared.getUser()?.mobile
        viewModel.updateParams(.mobile(CachingManager.shared.getUser()?.mobile ?? ""))
    }

    fileprivate func observeInput() {
        firstNameTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParams(.firstName(text ?? ""))
        }
        lastNameTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParams(.lastName(text ?? ""))
        }
        phoneNumberTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParams(.mobile(text ?? ""))
        }
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
            self.showDialogue(R.string.localizable.profileUpdated(),
                              message ?? "",
                              R.string.localizable.ok().uppercased()) {
                self.viewModel.popToProfile()
            }
        }
    }
}

// MARK: - Actions

extension EditProfileView {
    @IBAction func update(_ sender: UIButton) {
        showActivityIndicator()
        viewModel.update()
    }
}
