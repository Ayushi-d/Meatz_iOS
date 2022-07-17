//
//  ProfileView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//
import UIKit
final class ProfileView: MainView {
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var userNameLabel: MediumLabel?
    @IBOutlet private var emailLabel: BaseLabel?
    @IBOutlet weak var containerView: UIView!
    var viewModel: ProfileVMProtcol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationItems(false)
        onError()
        onCompletion()
        showLoginView()
    }

    private func showLoginView(){
        let vc = R.storyboard.boxes.loginFirstAlertController()
        vc?.coordinator = viewModel?.coordinator
//        guard CachingManager.shared.isLogin else {
//            addChildController(containerView, child: vc)
//            return
//        }
        
        if CachingManager.shared.isLogin {
            vc?.removeChild()
            showLoading()
            viewModel.onViewDidLoad()
        } else {
            addChildController(containerView, child: vc)
        }

    }
    
    fileprivate func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.showToast("", err.describtionError, completion: nil)
            self.hideLoading()
        }
    }
    fileprivate func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.hideLoading()
            self.userNameLabel?.text = self.viewModel.userName
            self.emailLabel?.text = self.viewModel.email
            self.tableView?.reloadData()
        }
        
        viewModel.showActivityIndicator.binding = { [weak self] status in
            guard let self = self else { return }
            guard let status = status else { return }
            if status {
                self.showActivityIndicator()
            } else {
                self.hideActivityIndicator()
            }
        }
    }
    
    
    override func notificationPressed() {
        viewModel.goToNotification()
    }
    
    deinit {}
}
// MARK: - Actions
extension ProfileView {
    @IBAction func logout(_ sender: UIButton) {
        showDialogue(R.string.localizable.logout(),
                     R.string.localizable.areYouSureYouWantToLogout(),
                     R.string.localizable.yes())
        {[weak self] in
            guard let self = self else{return}
            self.viewModel.logout()
        }
    }
    @IBAction func login(_ sender : UIButton){
        viewModel.login()
    }
}
// MARK: - TableView
extension ProfileView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ProfileMenuCell.self, indexPath: indexPath)
        cell.viewModel = viewModel.viewModelForCell(at: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}


extension ProfileView {
    private func showLoading(){
        startShimmerAnimation()
        tableView?.startShimmerAnimation(withIdentifier: ProfileMenuCell.identifier)
    }
    
    private func hideLoading(){
      stopShimmerAnimation()
        tableView?.stopShimmerAnimation()
    }
}
