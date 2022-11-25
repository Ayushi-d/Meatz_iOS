//
//  ProfileView.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//
import UIKit
import Alamofire

final class ProfileView: MainView {
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var userNameLabel: MediumLabel?
    @IBOutlet private var emailLabel: BaseLabel?
    @IBOutlet weak var containerView: UIView!
    var viewModel: ProfileVMProtcol!
    @IBOutlet weak var topView: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationItems(false)
        styleTopView()
        onError()
        onCompletion()
        showLoginView()
    }

    
    private func styleTopView(){
        tableView!.clipsToBounds = true
        tableView!.layer.cornerRadius = 30
        tableView!.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
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
    
    @IBAction func myOrderTapped(_ sender: UIButton){
        viewModel.navigateToMyorders()
    }
    
    @IBAction func myAddressTapped(_ sender: UIButton){
        viewModel.navigateToWallet()
    }
    
    @IBAction func notificationTapped(_ sender: UIButton){
        viewModel.goToNotification()
    }
    
    @IBAction func lanaguageTapped(_ sender: UIButton){
        viewModel.popupToChangeLang()
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
        if indexPath.row == 8{
            showDialogue("Delete Account",
                         "Are you sure you want to delete account",
                         R.string.localizable.yes())
            {[weak self] in
                guard let self = self else{return}
                self.deleteAccount()
            }
        }
    }
    
    func deleteAccount(){
        AF.request("http://meatz-app.com/api/delete-account",method: .get, encoding: JSONEncoding.default, headers: SHeaders.shared.headers).responseJSON { response in
            switch(response.result)
            {
            case .success(let json):
                do {
                    print("success===",json)
                    let statusCode = response.response?.statusCode
                    let response = json as! NSDictionary
                    if(statusCode == 200)
                    {
                        print(response)
                        //let data = response.object(forKey: "data") as! NSDictionary
                        CachingManager.shared.deleteForKey() // Delete User From Keychain
                        CachingManager.shared.removeCurrentUser()
                        self.showToast("", "Account Deleted Successfully") {
                            self.viewModel.login()
                        }
                    }else{
                        let message = response.object(forKey: "error") as! String
                        print(message)
                    }
                }
            case .failure(let error):
                print("not sucess",error)
            }
        }
    }

//    private func performeLogout() {
//        CachingManager.shared.deleteForKey() // Delete User From Keychain
//        CachingManager.shared.removeCurrentUser()
//        login()
//    }
//
//    func login() {
//        authCoorinator?.start()
//    }
    
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
