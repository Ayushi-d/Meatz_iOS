//
//  MainFactory.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import Foundation

// MARK: - MainFactory

protocol MainFactoryProtocol {
    func tabBar() -> MainTabBarController
    func home() -> HomeView
    func shops() -> ShopsView
    func profile() -> ProfileView
    func boxes() -> MyBoxesView
    func settings() -> SettingsView
    func shopDetails(_ id: Int) -> ShopDetailsView
    func filterView(options: [CategoryModel], _ Selectedoptions: [CategoryModel], _ action: (([CategoryModel]) -> Void)?) -> FilterByView
    func sortView(_ option: SortOption?, _ action: ((_ option: SortOption) -> Void)?) -> SortByView
    func featured() -> FeaturedView
    func category(_ cat: CategoryModel) -> CategoryDetailsView
    func ourBoxes() -> OurBoxesView
    func box(_ id: Int) -> BoxDetailsView
    func search() -> SearchView
    func searchResult(_ tab: SearchTab, _ model: SearchModel) -> SearchResultView
    func editProfile(_ model: AuthModel) -> EditProfileView
    func changePass() -> ChangePassView
    func whishlist() -> WishlistView
    func myAddresses() -> MyAddressView
    func addAddress(_ areas: [AreaModel]) -> AddAddressView
    func areas(_ areas: [AreaModel], _ completion: @escaping ((CityModel) -> Void)) -> AreasView
    func boxProducts(boxId: Int)-> BoxProductsView
    func createBox()->AddBoxView
    func editAddress(_ model : AddressModel,_ areas : [AreaModel]) -> EditAddressView
    func orders(_ pushFromOrderState:Bool) -> MyOrdersView
    func orderDetails(_ id : Int) -> OrderDetailsView
    func changeLang()-> ChangeLangController
    func page(_ id: Int)->PageController
    func contactUs(_ contactInfo: ContactInfoModel)-> ContactUsController
    func productDetails(_ id : Int) -> ProductDetailsView
    func addToBoxes(_ action: (([BoxesDataModel]) -> Void)?) -> AddToBoxesView
    func notifications()->NotificationsView
    func cart()->CartController
    func cartGuestAlert(_ cartModel: CartDataModel?)->GuestAlertController
    func editProfileWithPhone(_ model : CartDataModel)->EditProfileWithPhoneController
    func checkout(_ model : CartDataModel) -> UpdateCheckoutViewController
    func checkoutAsGuest(_ address : AddressParameters,_ model : CartDataModel) -> UpdateCheckoutViewController
    func delivery(_ model : CartDataModel) -> DeliveryAddressView
    func checkoutSuccess(_ model : CheckoutModel) -> OrderSuccessView
    func checkoutError() -> OrderErrorView
    func payment(_ model : CheckoutModel) -> PaymentView
    func changePassAlert()->ChangePassAlertController
    func offersDetails(offerId: Int) -> OfferDetailsView
    //func popToCheckout()->CheckoutView
    func wallet() -> WalletView
    func successRecharge(model: CheckoutModel) -> SuccessRechargeWalletView
    func errorRecharge() -> ErrorRecharegeWalletView

}

final class MainFactory: MainFactoryProtocol {

    
    private weak var coordinator: MainCoordinator?
    init(_ coordinator: MainCoordinator?) {
        self.coordinator = coordinator
    }

    func tabBar() -> MainTabBarController {
        let tabBar = R.storyboard.main.mainTabBarController()!
        tabBar.coordinator = coordinator
        //TODO: append offer screen after home screen
        tabBar.controllers = [home(), offers(), boxes(), profile(), settings()]
        return tabBar
    }

    func home() -> HomeView {
        let homeVC = R.storyboard.main.homeView()!
        let vm = HomeViewModel(HomeRepo(), coordinator)
        homeVC.mainViewModel = MainViewViewModel(coordinator)
        homeVC.viewModel = vm
        return homeVC
    }
    
    func offers() -> OffersView {
        let offerVC = R.storyboard.offers.offersView()!
        let vm = OffersViewModel(repo: OffersRepo(), coordinator)
        offerVC.viewModel = vm
        offerVC.mainViewModel = MainViewViewModel(coordinator)
        return offerVC
    }
    
    func offersDetails(offerId: Int) -> OfferDetailsView {
        let offerDetailsVC = R.storyboard.offers.offerDetailsView()!
        let vm = OfferDetailsViewModel(offerId: offerId, OfferDetailsRepo(), coordinator)
        offerDetailsVC.viewModel = vm
        offerDetailsVC.mainViewModel = MainViewViewModel(coordinator)
        return offerDetailsVC
    }

    func shops() -> ShopsView {
        let shopsVC = R.storyboard.main.shopsView()!
        shopsVC.viewModel = ShopsViewModel(ShopsRepo(), coordinator)
        shopsVC.mainViewModel = MainViewViewModel(coordinator)
        return shopsVC
    }

    func profile() -> ProfileView {
        let profileVC = R.storyboard.main.profileView()!
        profileVC.viewModel = ProfileViewModel(ProfileRepo(), coordinator)
        profileVC.mainViewModel = MainViewViewModel(coordinator)
        return profileVC
    }
    
    func wallet() -> WalletView {
        let vc = R.storyboard.wallet.walletView()!
        let vm = WalletViewModel(WalletRepo(), coordinator)
        vc.viewModel = vm
        return vc
    }
    
    func successRecharge(model: CheckoutModel) -> SuccessRechargeWalletView {
        let vc = R.storyboard.wallet.successRechargeWalletView()!
        let vm = SucsessRechargeWalletViewModel(model: model, coordinator)
        vc.viewModel = vm
        return vc
    }
    
    func errorRecharge() -> ErrorRecharegeWalletView {
        return R.storyboard.wallet.errorRecharegeWalletView()!
    }

    func boxes() -> MyBoxesView {
        let boxesVC = R.storyboard.boxes.myBoxesView()!
        boxesVC.viewModel = MyBoxesViewModel(repo: MyBoxesRepo(), coordinator)
        boxesVC.mainViewModel = MainViewViewModel(coordinator)
        return boxesVC
    }

    func settings() -> SettingsView {
        let vc = R.storyboard.settings.settingsView()!
        let vm = SettingsViewModel(repo: SettingsRepo(), coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        vc.viewModel = vm
        return vc
    }

    func shopDetails(_ id: Int) -> ShopDetailsView {
        let vc = R.storyboard.main.shopDetailsView()!
        let vm = ShopDetailsViewModel(ShopDetailsRepo(), coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        vm.shopID = id
        vc.viewModel = vm
        return vc
    }

//     [FilterOption],((_ options : [FilterOption])->Void)?)
    func filterView(options: [CategoryModel], _ selectedOptions: [CategoryModel], _ action: (([CategoryModel]) -> Void)?) -> FilterByView {
        let vc = R.storyboard.main.filterByView()!
        let vm = FilterViewModel(options, selectedOptions)
        vm.didSelectOption = action
        vc.viewModel = vm
        return vc
    }

    func sortView(_ option: SortOption?, _ action: ((_ option: SortOption) -> Void)?) -> SortByView {
        let vc = R.storyboard.main.sortByView()!
        let vm = SortViewModel(option)
        vm.didSelectOption = action
        vc.viewModel = vm
        return vc
    }

    func featured() -> FeaturedView {
        let vc = R.storyboard.main.featuredView()!
        vc.mainViewModel = MainViewViewModel(coordinator)
        let vm = FeaturedViewModel(FeaturedRepo(), coordinator)
        vc.viewModel = vm
        return vc
    }

    func category(_ cat: CategoryModel) -> CategoryDetailsView {
        let vc = R.storyboard.main.categoryDetailsView()!
        vc.mainViewModel = MainViewViewModel(coordinator)
        let vm = CategoryDetailsViewModel(ShopsRepo(), coordinator)
        vm.category = cat
        vc.viewModel = vm
        return vc
    }

    func ourBoxes() -> OurBoxesView {
        let vc = R.storyboard.main.ourBoxesView()!
        vc.mainViewModel = MainViewViewModel(coordinator)
        vc.viewModel = OurBoxesViewModel(OurBoxesRepo(), coordinator)
        return vc
    }

    func box(_ id: Int) -> BoxDetailsView {
        let vc = R.storyboard.main.boxDetailsView()!
        let vm = BoxDetailsViewModel(BoxDetailsRepo(), coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        vm.id = id
        vc.viewModel = vm
        return vc
    }

    func search() -> SearchView {
        let vc = R.storyboard.main.searchView()!
        let vm = SearchViewModel(SearchRepo(), coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        vc.viewModel = vm
        return vc
    }

    func searchResult(_ tab: SearchTab, _ model: SearchModel) -> SearchResultView {
        let vc = R.storyboard.main.searchResultView()!
        let vm = SearchResultViewModel(model, coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        vm.currentSelectedTab = tab
        vc.viewModel = vm
        return vc
    }

    func editProfile(_ model: AuthModel) -> EditProfileView {
        let vc = R.storyboard.main.editProfileView()!
        let vm = EditProfileViewModel(ProfileRepo(), coordinator)
        //vm.profileInfoModel = model
        vc.mainViewModel = MainViewViewModel(coordinator)
        vc.viewModel = vm
        return vc
    }

    func changePass() -> ChangePassView {
        let vc = R.storyboard.main.changePassView()!
        vc.viewModel = ChangePassViewModel(ChangePassRepo(), coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        return vc
    }

    func whishlist() -> WishlistView {
        let vc = R.storyboard.main.wishlistView()!
        vc.viewModel = WhishlistViewModel(WhishlistRepo(), coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        return vc
    }

    func myAddresses() -> MyAddressView {
        let vc = R.storyboard.main.myAddressView()!
        vc.viewModel = MyAddressViewModel(MyAddressRepo(), coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        return vc
    }
    
    func addAddress(_ areas: [AreaModel]) -> AddAddressView {
        let vc = R.storyboard.main.addAddressView()!
        let vm =  AddAddressViewModel(AddAddressRepo(), coordinator)
        vm.setAreas(areas)
        vc.mainViewModel = MainViewViewModel(coordinator)
        vc.viewModel = vm
        return vc
    }
   
    func areas(_ areas: [AreaModel], _ completion: @escaping ((CityModel) -> Void)) -> AreasView {
        let vc = R.storyboard.main.areasView()!
        let vm = AreasViewModel(areas, coordinator)
        vm.didSelectCityWith = completion
        vc.viewModel = vm
        return vc
    }
    
    func boxProducts(boxId: Int) -> BoxProductsView {
        let vc = R.storyboard.boxes.boxProductsView()!
        let vm = BoxProductsViewModel(repo: BoxProductsRepo(), coordinator, boxId: boxId)
        vc.viewModel = vm
        vc.mainViewModel = MainViewViewModel(coordinator)
        return vc
    }
    
    func createBox() -> AddBoxView {
        let vc = R.storyboard.boxes.addBoxView()!
        let vm = AddBoxViewModel(addBoxRepo(), coordinator)
        vc.viewModel = vm
        vc.mainViewModel = MainViewViewModel(coordinator)
        return vc
    }
    func editAddress(_ model: AddressModel, _ areas: [AreaModel]) -> EditAddressView {
        let vc = R.storyboard.main.editAddressView()!
        let vm = EditAddressViewModel(EditAddressRepo(), coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        vm.address = model
        vm.setAreas(areas)
        vc.viewModel = vm
        return vc
    }
    
    func orders(_ pushFromOrderState:Bool) -> MyOrdersView {
        let vc = R.storyboard.main.myOrdersView()!
        vc.viewModel = MyOrdersViewModel(MyOrdersRepo(), coordinator, pushedFromOrderState: pushFromOrderState)
        vc.mainViewModel = MainViewViewModel(coordinator)
        return vc 
    }
    
    func orderDetails(_ id: Int) -> OrderDetailsView {
        let vc = R.storyboard.main.orderDetailsView()!
        let vm = OrderDetailsViewModel(OrderDetailsRepo(), coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        vm.orderID = id
        vc.viewModel = vm
        return vc 
    }
    
    func changeLang() -> ChangeLangController {
        let vc = R.storyboard.settings.changeLangController()!
        vc.coordinator = coordinator
        return vc
    }
    
    func page(_ id: Int) -> PageController {
        let vc = R.storyboard.settings.pageController()!
        let vm = PageViewModel(repo: PageRepo(), id: id)
        vc.mainViewModel = MainViewViewModel(coordinator)
        vc.viewModel = vm
        return vc
    }
      func productDetails(_ id: Int) -> ProductDetailsView {
        let vc = R.storyboard.main.productDetailsView()!
        let vm = ProductDetailsViewModel(ProductDetailsRepo(), coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        vm.ID = id
        vc.viewModel = vm
        return vc
    }
    
    func contactUs(_ contactInfo: ContactInfoModel) -> ContactUsController {
        let vc = R.storyboard.settings.contactUsController()!
        let vm = ContactUsViewModel(ContactUsRepo(), contactInfo: contactInfo, coordinator: coordinator)
        vc.viewModel = vm
        vc.mainViewModel = MainViewViewModel(coordinator)
        return vc
    }

     func addToBoxes(_ action: (([BoxesDataModel]) -> Void)?) -> AddToBoxesView{
        let vc = R.storyboard.main.addToBoxesView()!
        let vm = AddToBoxesViewModel(MyBoxesRepo(), coordinator)

        vm.didSelectBoxes = action
        vc.viewModel = vm
        return vc
    }
    func notifications() -> NotificationsView {
        let vc = R.storyboard.main.notificationsView()!
        vc.viewModel = NotificationsViewModel(NotificationsRepo(), coordinator)
        vc.mainViewModel = MainViewViewModel(coordinator)
        return vc 
    }
    
    func cart() -> CartController {
        let vc = R.storyboard.cart.cartController()!
        let vm = CartViewModel(repo: CartRepo(), coordinator)
        vc.setViewModel(vm)
        return vc
    }
    
    func cartGuestAlert(_ cartModel: CartDataModel?) -> GuestAlertController {
        let vc = R.storyboard.cart.guestAlertController()!
        let vm = CartGuestAlertViewModel(coordinator, cartModel: cartModel)
        vc.setViewModel(vm)
        return vc 
    }
    
    func editProfileWithPhone(_ model : CartDataModel) -> EditProfileWithPhoneController {
        let vc = R.storyboard.cart.editProfileWithPhoneController()!
        let vm = EditProfileWithPhoneViewModel(ProfileRepo(), coordinator)
        vm.model = model
        vc.viewModel = vm
        return vc
    }
    //MARK:- Checkout 
    func checkout(_ model: CartDataModel) -> UpdateCheckoutViewController {
        let vc = R.storyboard.checkout.updateCheckoutViewController()!
        let vm = UpdateCheckoutViewModel(CheckoutRepo(), coordinator, false, guestAddress: nil)
//        vm.cartModel = model
        vc.viewModel = vm
        return vc 
    }
    
    func checkoutAsGuest(_ address: AddressParameters, _ model: CartDataModel) -> UpdateCheckoutViewController {
        let vc = R.storyboard.checkout.updateCheckoutViewController()!
        let vm = UpdateCheckoutViewModel(CheckoutRepo(), coordinator, true, guestAddress: address)
//        vm.cartModel = model
//        vm.guestAddress = address
//        vm.isCheckoutAsGuest = true
        vc.viewModel = vm
        return vc
    }
    func delivery(_ model : CartDataModel) -> DeliveryAddressView {
        let vc = R.storyboard.main.deliveryAddressView()!
        let vm = DeliveryAddressViewModel(MyAddressRepo(),coordinator!)
        vm.cartModel = model
        vc.viewModel = vm
        return vc
    }
    
    func checkoutError() -> OrderErrorView {
        let vc = R.storyboard.checkout.orderErrorView()!
        vc.viewModel = OrderErrorViewModel(coordinator)
        return vc
    }
    
    func checkoutSuccess(_ model: CheckoutModel) -> OrderSuccessView {
        let vc = R.storyboard.checkout.orderSuccessView()!
        vc.viewModel = OrderSuccessViewModel(model, coordinator)
        return vc
    }
    
    func payment(_ model: CheckoutModel) -> PaymentView {
        let vc = R.storyboard.checkout.paymentView()!
        vc.viewModel = PaymentViewModel(model, coordinator)
        return vc 
    }
    
    func changePassAlert() -> ChangePassAlertController {
        let vc = R.storyboard.main.changePassAlertController()!
        vc.coordinator = coordinator
        return vc
    }
    
//    func popToCheckout() -> CheckoutView {
//        let vc = R.storyboard.checkout.checkoutView()!
//        let vm = CheckoutViewModel(CheckoutRepo(), coordinator)
//        vc.viewModel = vm
//        return vc
//    }
}

// MARK: - Destinations

enum MainDestination: Destination {
    case tab
    case profile
    case shopDetails(Int) /// shop id
    case filterView(options: [CategoryModel],[CategoryModel], ((_ options: [CategoryModel]) -> Void)?) /// Select action
    case sort(SortOption?, ((_ option: SortOption) -> Void)?)
    case featured
    case category(CategoryModel)
    case box(Int) /// box id
    case product(Int) /// product id
    case ourBoxes
    case search
    case searchResult(SearchTab, SearchModel)
    case editProfile(AuthModel)
    case changPass
    case whishlist
    case adddresses
    case boxDetails(Int)
    case addAddress([AreaModel])
    case areas([AreaModel],((_ city : CityModel) -> Void))
    case boxProducts(Int)
    case createBox
    case pop
    case popToCheckout
    case editAddress(AddressModel,[AreaModel])
    case orders(Bool)
    case orderDetails(Int)
    case changeLang
    case page(Int)
    case contactUs(ContactInfoModel)
    case addToBoxesDialog((([BoxesDataModel]) -> Void)?)
    case notifications
    case cart
    case cartGuestAlert(CartDataModel?)
    case EditProfileWithPhone(CartDataModel)
    case checkout(CartDataModel)
    case checkoutGuest(AddressParameters,CartDataModel)
    case deliveryAddress(CartDataModel)
    case checkoutSuccess(CheckoutModel)
    case checkoutError
    case payment(CheckoutModel)
    case terms
    case changePassAlert
    case offerDetails(Int)
    case wallet
    case successRechageWallet(model: CheckoutModel)
    case errorRechargeWallet
    case myWalletAgain
}
