//
//  UIView + Extension.swift
//  Asnan Tower
//
//  Created by Mohamed Zead on 12/31/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import Foundation
import UIKit

typealias Completion = (()->Void)

extension UIView{
    
    func setShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    @IBInspectable var isShadowing : Bool{
        set(newValue){
            guard newValue else{return}
            setShadow()
        }get{
            return self.isShadowing
        }
    }
    // border width
    @IBInspectable var BorderW :CGFloat{
        set(newValue){
            layer.borderWidth = newValue
        }get{
            return layer.borderWidth
        }
    }
    // border color
    @IBInspectable var BorderC:UIColor{
        set(newValue){
            layer.borderColor = newValue.cgColor
        }get{
            return UIColor.black
        }
    }
    // border corner
    @IBInspectable var CCorner:CGFloat{
        set(newVal){
            layer.cornerRadius = newVal
        }get{
            return layer.cornerRadius
        }
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    
    func constraint(block: (UIView) -> ()) {
        translatesAutoresizingMaskIntoConstraints = false
        block(self)
    }
    
    
    @discardableResult func safeAreaTop(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = topAnchor.constraint(equalTo: constraintToView.safeAreaLayoutGuide.topAnchor, constant: padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func top(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = topAnchor.constraint(equalTo: constraintToView.topAnchor, constant: padding)
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func topToBottom(ofView view: UIView, withPadding padding: CGFloat) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func topToCenterY(ofView view: UIView, withPadding padding: CGFloat) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.centerYAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func leading(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = leadingAnchor.constraint(equalTo: constraintToView.leadingAnchor, constant: padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func leadingToTrailing(ofView view: UIView, withPadding padding: CGFloat) -> NSLayoutConstraint {
        let constraint = leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func leadingToCenterX(ofView view: UIView, withPadding padding: CGFloat) -> NSLayoutConstraint {
        let constraint = leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func trailing(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = trailingAnchor.constraint(equalTo: constraintToView.trailingAnchor, constant: -padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func bottom(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = bottomAnchor.constraint(equalTo: constraintToView.bottomAnchor, constant: -padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func safeAreaBottom(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = bottomAnchor.constraint(equalTo: constraintToView.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func centerX(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = centerXAnchor.constraint(equalTo: constraintToView.centerXAnchor, constant: padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    
    @discardableResult func centerY(_ padding: CGFloat, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = centerYAnchor.constraint(equalTo: constraintToView.centerYAnchor, constant: padding)
        
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func height(_ constant: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func width(_ constant: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult func height(multiplier: CGFloat, constant: CGFloat = 0, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = heightAnchor.constraint(equalTo: constraintToView.heightAnchor, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
        
    }
    
    @discardableResult func width(multiplier: CGFloat, constant: CGFloat = 0, toView view: UIView? = nil) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        constraint = widthAnchor.constraint(equalTo: constraintToView.widthAnchor, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
        
    }
    
    func pin(edges: Edge..., toView view: UIView? = nil) {
        
        let constraintToView: UIView
        
        if let view = view {
            constraintToView = view
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            constraintToView = superview
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        for edge in edges {
            switch edge {
            case .safeAreaTop(let padding):
                safeAreaTop(padding, toView: constraintToView)
            case .top(let padding):
                top(padding, toView: constraintToView)
            case .leading(let padding):
                leading(padding, toView: constraintToView)
            case .trailing(let padding):
                trailing(padding, toView: constraintToView)
            case .bottom(let padding):
                bottom(padding, toView: constraintToView)
            case .safeAreaBottom(let padding):
                safeAreaBottom(padding, toView: constraintToView)
            }
        }
    }
    
    func pinAllEdges(padding: CGFloat = 0, toView view: UIView? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let view = view {
            top(padding, toView: view)
            leading(padding, toView: view)
            trailing(padding, toView: view)
            bottom(padding, toView: view)
        } else {
            guard let superview = superview else { fatalError("Both view and superview are nil") }
            top(padding, toView: superview)
            leading(padding, toView: superview)
            trailing(padding, toView: superview)
            bottom(padding, toView: superview)
        }
    }
}


@IBDesignable
extension UIView {
    @IBInspectable var cornerRadious: CGFloat {
        get {
            self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

enum Edge {
    case safeAreaTop(CGFloat)
    case top(CGFloat)
    case leading(CGFloat)
    case trailing(CGFloat)
    case bottom(CGFloat)
    case safeAreaBottom(CGFloat)
}



extension UIView{
    func addConstrains(_ constrains: [NSLayoutConstraint]){
        for layout in constrains {
            self.addConstraint(layout)
        }
    }
}
