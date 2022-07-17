//
//  ProfileViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/11/21.
//

import Foundation

final class ProfileViewModel{
    
    var showActivityIndicator: Observable<Bool> = Observable(false)
    var state: State = .notStarted
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable.init(nil)
    var coordinator : Coordinator?
    private var repo : ProfileRepoProtocol?
    private var model : AuthModel?
    private lazy var authCoorinator : Coordinator?  = {
        let authCrd = AuthCoordinator(coordinator!.navigationController)
        authCrd.parent = coordinator
        return authCrd
    }()
    private var items : [ProfileMenuItemViewModel] =
        [ProfileMenuItem(title: R.string.localizable.myWallet(),icon: R.image.ic_wallet()!),
        ProfileMenuItem(title: R.string.localizable.editProfile(),icon: R.image.user()!),
         ProfileMenuItem(title: R.string.localizable.myOrders(), icon: R.image.myOrders()!),
         ProfileMenuItem(title: R.string.localizable.wishlist(), icon: R.image.wishlist()!),
         ProfileMenuItem(title: R.string.localizable.myAddress(), icon: R.image.myAddress()!),
         ProfileMenuItem(title: R.string.localizable.changePassword(), icon: R.image.password()!)]
    
    init(_ repo : ProfileRepoProtocol?,_ coordinator : Coordinator?) {
        self.coordinator = coordinator
        self.repo = repo
    }
}

//MARK:- Functionality
extension ProfileViewModel : ProfileVMProtcol{

    
    var numberOfItems: Int{
        return items.count
    }
    
    var userName: String{
        guard let userInfo = CachingManager.shared.getUser() else {return ""}
        return userInfo.firstName + " " + userInfo.lastName
    }
    var email: String{
        return model?.user.email ?? ""
    }
    func onViewDidLoad() {
        repo?.getProfileInfo({ [weak self](result) in
            guard let self = self else{return}
            switch result{
            case .success(let model):
                self.state = .success
                self.model = model
                self.items[0].value = model.user.wallet + " " + R.string.localizable.kwd()
                guard let completion = self.onRequestCompletion else{return}
                completion("")
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        })
    }
    func viewModelForCell(at index: Int) -> ProfileMenuItemViewModel {
        return items[index]
    }
    
    func didSelectItem(at index: Int) {
        switch index{
        case 0:
            coordinator?.navigateTo(MainDestination.wallet)
        case 1:
            guard let profileModel = model else{return}
            coordinator?.navigateTo(MainDestination.editProfile(profileModel))
        case 2:
            coordinator?.navigateTo(MainDestination.orders(false))
        case 3:
            coordinator?.navigateTo(MainDestination.whishlist)
        case 4:
            coordinator?.navigateTo(MainDestination.adddresses)
        case 5:
            coordinator?.navigateTo(MainDestination.changPass)
        default:break
        }
    }
    
    func logout() {
        showActivityIndicator.value = true
        repo?.logout({ [weak self] result in
            guard let self = self else { return }
            self.showActivityIndicator.value = false
            switch result {
            case .success:
                self.state = .success
                self.performeLogout()
            case .failure(let error):
                self.state = .finishWithError(error)
                self.requestError?.value = error
            }
        })
    }
    
    private func performeLogout() {
        CachingManager.shared.deleteForKey() // Delete User From Keychain
        CachingManager.shared.removeCurrentUser()
        login()
    }
    
    func login() {
        authCoorinator?.start()
    }
    func goToNotification() {
        coordinator?.navigateTo(MainDestination.notifications)
    }
}



protocol ProfileVMProtcol : ViewModel{
    var showActivityIndicator: Observable<Bool> { get set }
    var numberOfItems : Int{get}
    var userName : String{get}
    var email : String{get}
    var coordinator : Coordinator?{get set}
    func onViewDidLoad()
    func viewModelForCell(at index : Int) -> ProfileMenuItemViewModel
    func didSelectItem(at index : Int)
    func logout()
    func login()
    func goToNotification()
}


