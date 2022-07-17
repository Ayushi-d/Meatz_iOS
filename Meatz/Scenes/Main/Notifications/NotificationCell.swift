//
//  NotificationCell.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import UIKit

final class NotificationCell: UITableViewCell {
    @IBOutlet private var notificationTitleLabel: BaseLabel?
    @IBOutlet private var dateLabel: MediumLabel?

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }

    var viewModel: NotificationCellViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            notificationTitleLabel?.text = vm.notificationContent
            dateLabel?.text = vm.date
        }
    }
}
