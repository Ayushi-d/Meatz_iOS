//
//  PaymentView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/26/21.
//

import UIKit
import WebKit

final class PaymentView: MainView {

    @IBOutlet private weak var webView: WKWebView?
    
    var viewModel : PaymentVMProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems(cartEnabled: false)
        setUpWebView()
        onError()
        showActivityIndicator()
        
    }
    
    fileprivate func setUpWebView(){
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        guard let url = viewModel?.paymentLink else{
            hideActivityIndicator()
            return
        }
        webView?.load(URLRequest(url: url))
    }
    
    fileprivate func onError() {
        viewModel?.requestError?.binding = { [weak self] err in
            guard let self = self, let error = err else { return }
            self.hideActivityIndicator()
            self.showToast("", error.describtionError, completion: nil)
        }
    }

}


//MARK:- WebKit navigation & UIDelegate
extension PaymentView : WKUIDelegate , WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideActivityIndicator()
    }
        
    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("-----------------------------------",navigationAction.request.url?.absoluteString ?? "")
        let linkString = navigationAction.request.url?.absoluteString ?? ""
        if linkString.contains("success") || linkString.contains("payment_fail"){
            decisionHandler(.cancel)
            if linkString.contains("success"){
                /// commit loading payment link to clear cart
                webView?.load(URLRequest(url: navigationAction.request.url!))
                webView?.uiDelegate = nil
                webView?.navigationDelegate = nil
                viewModel?.parsePaymentURL(linkString)
//                viewModel?.showSuccessView()
            }else{
                viewModel?.showErrorView()
            }
        } else {
            decisionHandler(.allow)
        }
    }
}



