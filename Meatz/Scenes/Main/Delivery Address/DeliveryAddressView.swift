//
//  DeliveryAddressView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/25/21.
//

import UIKit

final class DeliveryAddressView: MainView {
    @IBOutlet private var phoneTextField: BaseTextField?
    @IBOutlet private var emailAddressTextField: BaseTextField?
    @IBOutlet private var customerNameTextField: BaseTextField?
    @IBOutlet private var otherInstructionsTextView: BaseTextView?
    @IBOutlet private var floorNumberTextField: BaseTextField?
    @IBOutlet private var aptNumberTextField: BaseTextField?
    @IBOutlet private var houseNoTextField: BaseTextField?
    @IBOutlet private var streetTextField: BaseTextField?
    @IBOutlet private var blockTextField: BaseTextField?
    @IBOutlet private var areaTextField: BaseTextField?
    @IBOutlet private weak var addressName: BaseTextField!
    
    var viewModel: DeliveryAddressVMProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        otherInstructionsTextView?.placeholder = R.string.localizable.otherInstructions()
        addNavigationItems(cartEnabled: false)
        observeInput()
        onError()
        onCompletion()
        showActivityIndicator()
        viewModel.onViewDidLoad()
    }
}

// MARK: - Actions

extension DeliveryAddressView {
    @IBAction func continueAction(_ sender: UIButton) {
        viewModel.addAddress()
    }

    @IBAction func selectArea(_ sender: UIButton) {
        viewModel.chooseArea()
    }
}

// MARK: - Observation

extension DeliveryAddressView {
    fileprivate func observeInput() {
        customerNameTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParameters(.customerName(text ?? ""))
        }
        emailAddressTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParameters(.email(text ?? ""))
        }
        phoneTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParameters(.phone(text ?? ""))
        }
        
        addressName?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParameters(.addressName(text ?? ""))
        }
        blockTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParameters(.block(text ?? ""))
        }
        streetTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParameters(.street(text ?? ""))
        }
        houseNoTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParameters(.houseNumber(text ?? ""))
        }
        aptNumberTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParameters(.aptNum(text ?? ""))
        }

        floorNumberTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParameters(.floorNo(text ?? ""))
        }

        otherInstructionsTextView?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParameters(.notes(text ?? ""))
        }

        viewModel.areaName.binding = { [weak self] text in
            guard let self = self else { return }
            self.areaTextField?.text = text ?? ""
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
        }
    }
}
