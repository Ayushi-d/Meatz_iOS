//
//  ProfileViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/11/21.
//

import Foundation
import Alamofire
final class ProfileViewModel{
    
    var showActivityIndicator: Observable<Bool> = Observable(false)
    var state: State = .notStarted
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable.init(nil)
    var coordinator : Coordinator?
    private var repo : ProfileRepoProtocol?
    private var model : AuthModel?
    var contactInfo: ContactInfoModel?
    private var settings: [SettingsModel]? = []
    private lazy var authCoorinator : Coordinator?  = {
        let authCrd = AuthCoordinator(coordinator!.navigationController)
        authCrd.parent = coordinator
        return authCrd
    }()
//    private var items : [ProfileMenuItemViewModel] =
//        [ProfileMenuItem(title: R.string.localizable.myWallet(),icon: R.image.ic_wallet()!),
//        ProfileMenuItem(title: R.string.localizable.editProfile(),icon: R.image.user()!),
//         ProfileMenuItem(title: R.string.localizable.myOrders(), icon: R.image.myOrders()!),
//         ProfileMenuItem(title: R.string.localizable.wishlist(), icon: R.image.wishlist()!),
//         ProfileMenuItem(title: R.string.localizable.myAddress(), icon: R.image.myAddress()!),
//         ProfileMenuItem(title: R.string.localizable.changePassword(), icon: R.image.password()!)]
    
    private var items : [ProfileMenuItemViewModel] =
        [ProfileMenuItem(title: R.string.localizable.myAddress(),icon: R.image.myAddress()!),
          ProfileMenuItem(title: R.string.localizable.editProfile(),icon: R.image.user()!),
          ProfileMenuItem(title: R.string.localizable.wishlist(), icon: R.image.wishlist()!),
          ProfileMenuItem(title: "Contact US", icon: R.image.contactUs()!),
          ProfileMenuItem(title: "About Meatz", icon: R.image.newlogo()!),
          ProfileMenuItem(title: "Privacy Policy", icon: R.image.termsConditions()!),
          ProfileMenuItem(title: "Terms & Conditions", icon: R.image.termsConditions()!),
          ProfileMenuItem(title: R.string.localizable.changePassword(), icon: R.image.password()!),
         ProfileMenuItem(title: "Delete Account", icon: UIImage.init(named: "trashblack")!),
        ]
    
    init(_ repo : ProfileRepoProtocol?,_ coordinator : Coordinator?) {
        self.coordinator = coordinator
        self.repo = repo
    }
}

extension ProfileViewModel {
    
    private func responseHandeler(_ result: Result<[SettingsModel]?, ResultError>) {
        switch result {
        case .success(let model):
            self.settings = model
            guard let completion = self.onRequestCompletion else { return }
            completion("")
        case .failure(let error):
            self.requestError?.value = error
        }
    }
    
    private func contactInfoResponseHandeler(_ result: Result<ContactInfoModel?, ResultError>) {
        switch result {
        case .success(let model):
            self.contactInfo = model
        case .failure(let error):
            self.requestError?.value = error
        }
    }
}



//MARK:- Functionality
extension ProfileViewModel : ProfileVMProtcol{

    
    var numberOfItems: Int{
        return items.count
    }
    
    var contactInfoo: ContactInfoModel?{
        return contactInfo
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
        
        self.repo?.getSettings { [weak self] result in
            guard let self = self else { return }
            self.responseHandeler(result)
        }
        
        self.repo?.getContactInfo({ [weak self] result in
            guard let self = self else { return }
            self.contactInfoResponseHandeler(result)
        })
        
    }
    func viewModelForCell(at index: Int) -> ProfileMenuItemViewModel {
        return items[index]
    }
    
    func didSelectItem(at index: Int) {
        switch index{
        case 0:
            coordinator?.navigateTo(MainDestination.adddresses)
        case 1:
            guard let profileModel = model else{return}
            coordinator?.navigateTo(MainDestination.editProfile(profileModel))
        case 2:
            coordinator?.navigateTo(MainDestination.whishlist)
        case 3:
            coordinator?.navigateTo(MainDestination.contactUs(contactInfoo!))
        case 4:
            coordinator?.navigateTo(MainDestination.page(1))
        case 5:
            coordinator?.navigateTo(MainDestination.page(3))
        case 6:
            coordinator?.navigateTo(MainDestination.page(2))
        case 7:
            coordinator?.navigateTo(MainDestination.changPass)
        default:break
        }
    }
    
    func navigateToMyorders(){
        coordinator?.navigateTo(MainDestination.orders(false))
    }
    
    func navigateToMyaddress(){
        coordinator?.navigateTo(MainDestination.adddresses)
    }
    
    func navigateToWallet(){
        coordinator?.navigateTo(MainDestination.wallet)
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
    
    func popupToChangeLang() {
        coordinator?.present(MainDestination.changeLang)
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
    func navigateToMyorders()
    func navigateToMyaddress()
    func navigateToWallet()
    func popupToChangeLang()
}


