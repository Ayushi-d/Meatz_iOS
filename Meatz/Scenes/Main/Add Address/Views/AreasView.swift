//
//  AreasView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/13/21.
//

import UIKit

final class AreasView: UIViewController {
    @IBOutlet private var tableView: UITableView?
    var viewModel: AreasVMProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reloadData.binding = { [weak self] shouldReload in
            guard let self = self else { return }
            self.tableView?.reloadData()
        }
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.reloadData()
    }
}

// MARK: - TableView

extension AreasView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfAreas
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCitiesInArea(at: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AreaCell.self, indexPath: indexPath)
        cell.areaTitlLabel?.text = viewModel.titleForCity(at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCity(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerButton = BoldButton()
        headerButton.fontSize = 18
        headerButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        headerButton.setTitle(viewModel.titleForArea(at: section), for: .normal)
        headerButton.setTitleColor(R.color.meatzBlack(), for: .normal)
        headerButton.contentHorizontalAlignment = MOLHLanguage.isArabic() ? .right : .left
        headerButton.tag = section
        headerButton.addTarget(self, action: #selector(headerPressed(_:)), for: .touchUpInside)
    
        return headerButton
    }

    @objc fileprivate func headerPressed(_ sender : UIButton) {
        let section = sender.tag
        var indecies: [IndexPath] = []
        for i in 0..<viewModel.citiesCount(at: section) {
            indecies.append(IndexPath(row: i, section: section))
        }
        viewModel.didSelectArea(at: section)
        if viewModel.isExpanded(at: section) {
            tableView?.insertRows(at: indecies, with: .fade)
        } else {
            tableView?.deleteRows(at: indecies, with: .fade)
        }
        tableView?.reloadData()
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
