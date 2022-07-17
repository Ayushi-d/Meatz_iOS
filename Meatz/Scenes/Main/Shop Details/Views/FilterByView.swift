//
//  FilterByView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import UIKit

final class FilterByView: UIViewController {
    @IBOutlet private var tableView: UITableView?
    
    var viewModel: FilterVMProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func submitFilterAction(_ sender: Any) {
        viewModel.didFinishPickingOptions()
        dismiss(animated: false, completion: nil)
    }
}

// MARK: - UITableView Methods

extension FilterByView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfOptions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FilterTableViewCell.self, indexPath: indexPath)
        cell.option = viewModel.optionForCell(at: indexPath.row)
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
