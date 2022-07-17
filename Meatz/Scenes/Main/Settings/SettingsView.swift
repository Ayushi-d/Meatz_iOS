//
//  SettingsView.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/18/21.
//

import UIKit

enum socialItems: Int {
    case facebook = 0
    case insta = 1
    case twitter = 2

    var value: Int {
        return rawValue
    }
}

final class SettingsView: MainView {
    // MARK: - Outlets

    @IBOutlet var tableviewq: UITableView!
    @IBOutlet var switchNotification: UISwitch!
    @IBOutlet weak var footerArrowIcon: UIImageView!
    @IBOutlet weak var headerArrowIcon: UIImageView!
    let defaults = UserDefaults.standard
    

    // MARK: - ViewModel

    var viewModel: SettingsVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(MOLHLanguage.currentAppleLanguage())
        setupTableView()
        onError()
        onCompletion()
        switchNotification.set(offTint: #colorLiteral(red: 0.7646381259, green: 0.7647493482, blue: 0.7646138072, alpha: 1))
        if !CachingManager.shared.isFirstTimeOpenSetting{
            switchNotification.isOn = defaults.bool(forKey: "ON") }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MOLHLanguage.isArabic(){
            footerArrowIcon.image = R.image.backAr()
            headerArrowIcon.image = R.image.backAr()
        }else {
            footerArrowIcon.image = R.image.back1()
            headerArrowIcon.image = R.image.back1()
        }

        setNavigationItems(false)
        showLoading()
        viewModel.viewDidLoad()
    }

    override func notificationPressed() {
        viewModel.goToNotification()
    }
    
    @IBAction func socialActions(_ sender: UIButton) {
        var value: String?
        switch sender.tag {
        case socialItems.facebook.value:
            value = viewModel.contactInfoo?.facebook
        case socialItems.insta.value:
            value = viewModel.contactInfoo?.instagram
        case socialItems.twitter.value:
            value = viewModel.contactInfoo?.twitter
        default: break
        }
        SocialApi.link(value ?? "").openUrl()
    }

    @IBAction func switchNotificatiopnAction(_ sender: Any) {
        if switchNotification.isOn {
            defaults.set(true, forKey: "ON")
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.sound, .alert, .badge]) { _, error in
                if error == nil {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            CachingManager.shared.settingIsOpened()
            defaults.removeObject(forKey: "ON")
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }

    @IBAction func changeLangAction(_ sender: Any) {
        viewModel.popupToChangeLang()
    }
    
    @IBAction func navigateToContactUsAction(_ sender: Any) {
        viewModel.navigateToContactUs()
    }
}

// MARK: - Update UI

private extension SettingsView {
    func onError() {
        viewModel.requestError?.binding = { [weak self] error in
            guard let self = self, let err = error else { return }
            self.hideLoading()
            self.showToast("", err.describtionError, completion: nil)
        }
    }

    func onCompletion() {
        viewModel.onRequestCompletion = { [weak self] _ in
            guard let self = self else { return }
            self.hideLoading()
            self.tableviewq.reloadData()
        }
    }
}

// MARK: - TabeView Adapter

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        tableviewq.delegate = self
        tableviewq.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSettings ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SettingsViewCell.self, indexPath: indexPath)
        cell.model = viewModel.dequeCellForRow(at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectPages(at: indexPath)
    }
}


extension UISwitch {

    func set(offTint color: UIColor ) {
        let minSide = min(bounds.size.height, bounds.size.width)
        layer.cornerRadius = minSide / 2
        backgroundColor = color
        tintColor = color
    }
}

extension SettingsView {
    private func showLoading(){
        startShimmerAnimation()
        tableviewq?.startShimmerAnimation(withIdentifier: SettingsViewCell.identifier)
    }
    
    private func hideLoading(){
      stopShimmerAnimation()
        tableviewq?.stopShimmerAnimation()
    }
}
