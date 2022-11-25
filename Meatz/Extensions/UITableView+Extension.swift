//
//  UITableView+Extension.swift
//  Asnan Tower
//
//  Created by Mohamed Zead on 1/14/21.
//  Copyright © 2021 Spark Cloud. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func dequeue<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }

    func reloadDataWithAutoSizingCellWorkAround() {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
    }
    
    
    func emptyMessage(message: String, image: UIImage? = nil, details: String? = nil) {
        /// Title
        let messageLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = FontsType.medium.getFontWithSize(14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        /// Image
        let messageImageView: UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            return image
        }()
        
        /// Details
        let messageDetailsLbl: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = FontsType.regular.getFontWithSize(14)
            label.textColor = .lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(messageImageView)
            stackView.addArrangedSubview(messageLabel)
            stackView.addArrangedSubview(messageDetailsLbl)
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.spacing = 30
            return stackView
        }()
        
        if image == nil {
            messageImageView.isHidden = false
        }
        if details == nil {
            messageDetailsLbl.isHidden = true
        }
        
        messageImageView.image = image
        messageLabel.text = message
        messageDetailsLbl.text = details
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        backgroundView = view
        backgroundView!.addSubview(stackView)
        
        stackView.constraint {
            $0.centerX(0)
            $0.centerY(0)
            $0.width(UIScreen.main.bounds.width - 16)
        }
    }
}
