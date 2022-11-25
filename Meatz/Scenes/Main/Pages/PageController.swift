//
//  PageController.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import UIKit
import WebKit

final class PageController: MainView {
    // MARK: - ViewModel
    
    var viewModel: PageViewModel!
    
    //MARK:- Outlets
    
    @IBOutlet weak var titleLbl: MediumLabel!
    @IBOutlet weak var  dummyContent: UITextView?
    @IBOutlet weak var contentWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems(cartEnabled: false)
        onError()
        onCompletion()
        contentWebView.isOpaque = false
        contentWebView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        viewModel.viewDidLoad()
    }
}
// MARK: - Update UI

private extension PageController {
    func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.hideLoading()
            self.showToast("", err.describtionError, completion: nil)
        }
    }

    func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] data in
            guard let self = self else { return }
            self.titleLbl.text = data?.title
            self.contentWebView.loadHTMLString(data?.content ?? "", baseURL: nil)
            self.hideLoading()
        }
    }
}

// MARK:- Loading
extension PageController {
    func showLoading(){
        startShimmerAnimation()
    }
    
    private func hideLoading(){
        stopShimmerAnimation()
        dummyContent?.isHidden = true
    }
}

