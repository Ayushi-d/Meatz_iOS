//
//  EditAddressView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/14/21.
//


import UIKit

final class EditAddressView: MainView {
    @IBOutlet private var otherInstructionsTextView: BaseTextView?
    @IBOutlet private var addressNameTextField: BaseTextField?
    @IBOutlet private var floorNumberTextField: BaseTextField?
    @IBOutlet private var aptNumberTextField: BaseTextField?
    @IBOutlet private var houseNoTextField: BaseTextField?
    @IBOutlet private var streetTextField: BaseTextField?
    @IBOutlet private var blockTextField: BaseTextField?
    @IBOutlet private var areaTextField: BaseTextField?
    
    var viewModel: EditAddressVMProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        otherInstructionsTextView?.placeholder = R.string.localizable.otherInstructions()
        addNavigationItems(cartEnabled: false)
        loadData()
        observeInput()
        onError()
        onCompletion()
    }
}

// MARK: - Actions

extension EditAddressView {
    @IBAction func EditAddress(_ sender: UIButton) {
        showActivityIndicator()
        viewModel.EditAddress()
    }
    
    @IBAction func selectArea(_ sender: UIButton) {
        viewModel.chooseArea()
    }
}

// MARK: - Observation

extension EditAddressView {
    fileprivate func observeInput() {
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
        addressNameTextField?.observe = { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateParameters(.addressName(text ?? ""))
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
            self.showToast("", message ?? "") { [weak self] in
                guard let self = self else{return}
                self.viewModel.back()
            }
        }
    }
    
    fileprivate func  loadData(){
        let address = viewModel.address
        addressNameTextField?.text = address?.addressName ?? ""
        areaTextField?.text = address?.area.name ?? ""
        blockTextField?.text = address?.block ?? ""
        streetTextField?.text = address?.street ?? ""
        houseNoTextField?.text = address?.houseNumber ?? ""
        otherInstructionsTextView?.set(address?.notes ?? "")
        aptNumberTextField?.text = address?.apartmentNo ?? ""
        floorNumberTextField?.text = address?.levelNo ?? ""
    }
}
