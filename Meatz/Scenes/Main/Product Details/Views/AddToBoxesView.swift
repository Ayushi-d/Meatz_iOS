//
//  AddToBoxesView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import UIKit

final class AddToBoxesView: UIViewController {
    @IBOutlet private var optionsView: UIView?
    var viewModel: AddToBoxesVMProtocol!
    @IBOutlet private var tableView: UITableView?
    @IBOutlet weak var viewHieghtConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        onError()
        onCompletion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        optionsView?.isHidden = true
        showActivityIndicator()
        viewModel.onViewDidload()
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
            let isEmpty = self.viewModel.numberOfBoxes == 0
            self.optionsView?.isHidden = isEmpty
            guard !isEmpty else {
            self.optionsView?.isHidden = true
            self.showDialogue(R.string.localizable.addToMyBox(),
                              R.string.localizable.pleaseAddABoxForAddingTheProductInBox(),
                              R.string.localizable.addBox(), { [weak self] in
                                ///Action
                                guard let self = self else { return }
                                self.viewModel.addNewBox()
                                self.dismiss(animated: false, completion: nil)
                                  }, { [weak self] in /// Dimiss Action
                                    self?.dismiss(animated: false, completion: nil)
                                  })

                return
            }
            if CGFloat(40 * self.viewModel.numberOfBoxes) + 230 < 600 {
                self.viewHieghtConstraint.constant = CGFloat(40 * self.viewModel.numberOfBoxes) + 220
            }
            
            self.tableView?.reloadData()
        }
    }
}

// MARK: - Actions

extension AddToBoxesView {
    @IBAction func add(_ sender: UIButton) {
        viewModel.add()
    }

    @IBAction func close(_ sender: UIButton) {
        viewModel.close()
    }
}

// MARK: - TableView

extension AddToBoxesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfBoxes
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FilterTableViewCell.self, indexPath: indexPath)
        cell.option = viewModel.boxForCell(at: indexPath.row)
        if viewModel.isSelected(at: indexPath.row) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isSelected(at: indexPath.row) {
            tableView.deselectRow(at: indexPath, animated: true)
            viewModel.didDeSelectItem(at: indexPath.row)
        } else {
            viewModel.didSelectItem(at: indexPath.item)
        }
    }
}
