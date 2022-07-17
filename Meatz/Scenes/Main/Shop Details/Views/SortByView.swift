//
//  SortByView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import Foundation

import UIKit

final class SortByView: UIViewController {
    @IBOutlet private var tableView: UITableView?
    var viewModel: SortVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func submitSortAction(_ sender: Any) {
        viewModel.didSelectItem  { [weak self] in
            guard let self = self else { return }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.dismiss(animated: false, completion: nil)
                        }
        }
    }
}

// MARK: - UITableView Methods

extension SortByView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfOptions
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SortTableViewCell.self, indexPath: indexPath)
        cell.option = viewModel.optionForCell(at: indexPath.row)
        if viewModel.isSelected(at: indexPath.row){
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.numberOfIndex = indexPath.row

    }
    
}
