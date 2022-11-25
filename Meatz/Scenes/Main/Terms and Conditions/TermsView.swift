//
//  TermsView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/29/21.
//

import UIKit
import WebKit
final class TermsView: MainView {
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var titleLabel: MediumLabel!

    var viewModel: TermsVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = R.color.meatzBg()
        addNavigationItems(cartEnabled: false)
        onError()
        onCompletion()
        showActivityIndicator()
        viewModel.onViewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.showToast("", error?.describtionError ?? "", completion: nil)
        }
    }

    fileprivate func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.loadData()
        }
    }

    fileprivate func loadData() {
        titleLabel.text = viewModel.title
        webView.loadHTMLString(viewModel.content, baseURL: nil)
    }
}
