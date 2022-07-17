//
//  UIViewController + Extension.swift
//  Asnan Tower
//
//  Created by Mohamed Zead on 12/29/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import UIKit

extension UIViewController {
    static func instance(_ SB: StoryBoard = .main) -> Self {
        let storyBoard = SB.storyboard
        let vc = storyBoard.instantiateViewController(identifier: identifier)
        return vc as! Self
    }
    
    static var identifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
    
    func setTitle(_ title: String, _ hidesBackTitle: Bool = true) {
        navigationItem.title = title
        guard hidesBackTitle else { return }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    }
    
    func showError(_ msg: ResultError) {
        let alert = UIAlertController(title: R.string.localizable.error(), message: msg.describtionError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        let activity = NVActivityIndicatorView(frame: .zero, type: .ballScaleMultiple, color: R.color.meatzRed(), padding: 10)
        activity.tag = 209020
        activity.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activity)
        NSLayoutConstraint.activate([
            activity.widthAnchor.constraint(equalToConstant: 100),
            activity.heightAnchor.constraint(equalToConstant: 100),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        activity.startAnimating()
    }
    
    func hideActivityIndicator() {
        guard let activity = view.viewWithTag(209020) as? NVActivityIndicatorView else { return }
        activity.stopAnimating()
        activity.removeFromSuperview()
    }
    
    func removeAnyIndicators() {
        view.subviews.forEach { subView in
            if subView.tag == 209020 {
                subView.removeFromSuperview()
            }
        }
    }
    
    func showDialogue(_ title: String, _ msg: String, _ actionTitle: String, _ action: @escaping () -> Void, _ dimissAction: (() -> Void)? = nil) {
        let dialogue = DialogueBuilder()
            .title(title)
            .message(msg)
            .action(actionTitle, action)
            .dismissAction(dimissAction)
            .build()
        dialogue.translatesAutoresizingMaskIntoConstraints = false
        appWindow?.addSubview(dialogue)
        NSLayoutConstraint.activate([
            dialogue.topAnchor.constraint(equalTo: appWindow!.topAnchor),
            dialogue.leadingAnchor.constraint(equalTo: appWindow!.leadingAnchor),
            dialogue.trailingAnchor.constraint(equalTo: appWindow!.trailingAnchor),
            dialogue.bottomAnchor.constraint(equalTo: appWindow!.bottomAnchor)
        ])
    }
    
    /// should be hidden
    func messageView(_ msg: String? = nil, _ image: UIImage? = nil, hide: Bool = false) {
        if hide {
            for view_ in view.subviews {
                if view_.tag == 1080 {
                    view_.removeFromSuperview()
                }
            }
        } else {
            if let image_ = image, let message = msg {
                let builder = DescriptiveViewBuilder()
                    .image(image_).message(message)
                let descriptiveView = builder.build()
                descriptiveView.translatesAutoresizingMaskIntoConstraints = false
                descriptiveView.tag = 1080
                view.addSubview(descriptiveView)
                NSLayoutConstraint.activate([
                    descriptiveView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    descriptiveView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    descriptiveView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    descriptiveView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    descriptiveView.heightAnchor.constraint(equalToConstant: 110)
                ])
                view.bringSubviewToFront(descriptiveView)
            }
        }
    }
    
    func showPopupVC(_ vc: UIViewController,
                     transition: UIModalTransitionStyle = .crossDissolve,
                     completion: (() -> Void)? = nil) {
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = transition
        self.present(vc, animated: true, completion: completion)
    }
    
    func dismissVC(fadedView: UIView) {
        UIView.transition(with: fadedView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                              fadedView.alpha = 0
        }) { completed in
            if completed {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    var appWindow: UIWindow? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window
    }
    
    func add(_ child: UIViewController?) {
        guard let child = child else { return }
        child.view.frame = view.bounds
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func addChildController(_ containerView: UIView?, child: UIViewController?) {
        guard let child = child else {
            return
        }
        let _view: UIView = containerView ?? view
        addChild(child)
        child.view.frame = _view.bounds
        _view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeChild() {
        children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
}

enum StoryBoard: String {
    case main = "Main"
    case auth = "Auth"
    case boxes = "Boxes"
    case settings = "Settings"
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
}

// MARK: - Toast

extension UIViewController {
    func showToast(_ title: String, _ msg: String, completion: (() -> Void)?) {
        let builder = ToastBuilder()
            .color(R.color.meatzRed()!)
            .message(msg)
            .title(title)
        let toastView = builder.build()
        showToast(toastView, completion)
    }
    
    fileprivate func showToast(_ toast: ToastView, _ completion: (() -> Void)?) {
        view.addSubview(toast)
        toast.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = toast.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 150)
        
        NSLayoutConstraint.activate([
            toast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            toast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            toast.heightAnchor.constraint(equalToConstant: 80),
            bottomConstraint
        ])
        UIView.animate(withDuration: 1, animations: {
            bottomConstraint.constant = -20
        }) { isCompleted in
            guard isCompleted else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                bottomConstraint.constant = 150
                self.view.layoutIfNeeded()
                toast.removeFromSuperview()
                (completion ?? {})()
            }
        }
    }
}


extension UINavigationController {
    
    func popTo<T: UIViewController>(_ type: T.Type) {
        guard let viewController = viewControllers.first(where: { $0 is T }) else { return }
        popToViewController(viewController, animated: true)
    }
}
