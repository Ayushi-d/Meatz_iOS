//
//  OneActionDialogue.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/23/21.
//

import Foundation
import UIKit

final class OneActionDialogue: UIView {
    private var dialogueHeight : NSLayoutConstraint?
    //MARK:- Setters
    var action: (() -> Void)?
    var dimissAction : (() -> Void)?
    
    var title : String?{
        didSet{
            titleLabel.text = title ?? ""
        }
    }
    var message : String?{
        didSet{
            messageLabel.text = message ?? ""
            let contentHeight = 220 + messageLabel.intrinsicContentSize.height
            dialogueHeight?.constant = contentHeight
            layoutIfNeeded()
        }
    }
    
    var actionTitle : String?{
        didSet{
            actionButton.setTitle(actionTitle ?? "", for: .normal)
        }
    }
    
    //MARK:- Views
    /// Title label for the dialogue
    private lazy var titleLabel: BaseLabel = {
        let label = MediumLabel()
        label.alignmentEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.fontSize = 20
        label.textColor = R.color.meatzBlack()
        return label
    }()
    
    /// close button to dismiss the dialogue
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(R.image.closeButton(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    /// Message label for the dialogue
    private lazy var messageLabel: UILabel = {
        let label = BaseLabel()
        label.alignmentEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.fontSize = 14
        label.numberOfLines = 3
        return label
    }()
    
    /// the action for the dialogue
    private lazy var actionButton: BaseButton = {
        let button = MediumButton()
        button.alignmentEnabled = false
        button.fontSize = 18
        button.CCorner = 25
        button.setTitleColor(R.color.meatzRed(), for: .normal)
        button.backgroundColor = R.color.maetzLightRed()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    /// The body view for the dialogue that contains all the subViews
    private lazy var dialogueBodyView: UIView = {
        let dView = UIView()
        dView.translatesAutoresizingMaskIntoConstraints = false
        dView.CCorner = 10
        dView.backgroundColor = .white
        return dView
    }()
    private lazy var containerView : UIView = {
        let cView = UIView()
        cView.translatesAutoresizingMaskIntoConstraints = false
        return cView
    }()
    //MARK:- Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInitialProperties()
        addSubview(containerView)
        setContainerViewConstraints()
        addSubview(dialogueBodyView)
        setDialogBodyConstraints()
        addBodySubViews()
        setBodySubViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    private func setInitialProperties() {
        backgroundColor = .clear
        containerView.backgroundColor = .black
        containerView.alpha = 0.65
    }
    //MARK:- Actions
    @objc private func actionButtonPressed() {
        (action ?? {})()
        removeFromSuperview()
    }
    
    @objc private func closeButtonPressed() {
        (dimissAction ?? {})()
        removeFromSuperview()
    }
    //MARK:- Constraints
    private func addBodySubViews() {
        dialogueBodyView.addSubview(closeButton)
        dialogueBodyView.addSubview(actionButton)
        dialogueBodyView.addSubview(messageLabel)
        dialogueBodyView.addSubview(titleLabel)
    }
    
    private func setBodySubViewConstraints() {
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: dialogueBodyView.trailingAnchor, constant: -20),
            closeButton.topAnchor.constraint(equalTo: dialogueBodyView.topAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: dialogueBodyView.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: dialogueBodyView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: dialogueBodyView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: dialogueBodyView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 23),
            messageLabel.leadingAnchor.constraint(equalTo: dialogueBodyView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: dialogueBodyView.trailingAnchor, constant: -20),
            
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.centerXAnchor.constraint(equalTo: dialogueBodyView.centerXAnchor),
            /// Updating frame of action button to increase more than its title
            actionButton.widthAnchor.constraint(equalToConstant: 118)
        ])
    }
    
    private func setDialogBodyConstraints(){
        let contentHeight = 220 + messageLabel.intrinsicContentSize.height
        dialogueHeight = dialogueBodyView.heightAnchor.constraint(equalToConstant: contentHeight)
        NSLayoutConstraint.activate([
            dialogueBodyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 46),
            dialogueBodyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -46),
            dialogueBodyView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dialogueHeight!
        ])
    }
    
    private func setContainerViewConstraints(){
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

