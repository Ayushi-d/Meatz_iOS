//
//  Created by Mohamed Zead on 4/4/21.
//

import Foundation
import UIKit

struct ToastBuilder {
    private var view: ToastView
    init() {
        view = ToastView(frame: .zero)
    }

    func title(_ titleStr: String) -> ToastBuilder {
        view.titleLabel.text = titleStr
        return self
    }

    func message(_ msg: String) -> ToastBuilder {
        view.messageLabel.text = msg
        return self
    }

    func color(_ color: UIColor) -> ToastBuilder {
        view.backgroundColor = color
        return self
    }
    func build()->ToastView{
        return view
    }
}

class ToastView: BaseView {
    lazy var titleLabel: BaseLabel = {
        let label = BaseLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.fontSize = 16
        label.textColor = .white
        label.alignmentEnabled = false
        label.textAlignment = .center
        return label
    }()

    lazy var messageLabel: BaseLabel = {
        let label = BaseLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.fontSize = 14
        label.textColor = .white
        label.alignmentEnabled = false
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        shadowColor = .clear
        borderColor = .clear
        cornerRadius = 12
        addSubview(titleLabel)
        addSubview(messageLabel)
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setUpConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
