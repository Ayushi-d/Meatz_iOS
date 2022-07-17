//
//  SettingsViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/18/21.
//

import UIKit

final class SettingsViewModel {
    private var repo: SettingsRepoProtocol?
    private var coordinator: Coordinator?
    private var settings: [SettingsModel]? = []
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable(nil)
    var state: State = .notStarted
    var notificationIsOn: Observable<Bool> = Observable(true)
    var contactInfo: ContactInfoModel?

    init(repo: SettingsRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

// MARK: - Request

extension SettingsViewModel {
    func viewDidLoad() {
        
        self.repo?.getSettings { [weak self] result in
            guard let self = self else { return }
            self.responseHandeler(result)
        }
        
        self.repo?.getContactInfo({ [weak self] result in
            guard let self = self else { return }
            self.contactInfoResponseHandeler(result)
        })
    }
}

// MARK: - Handel Response

extension SettingsViewModel {
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

// MARK: - VMProtocolImpl

extension SettingsViewModel: SettingsVMProtocol {
    var numberOfSettings: Int? {
        return self.settings?.count
    }
    
    var contactInfoo: ContactInfoModel?{
        return contactInfo
    }

    func dequeCellForRow(at index: IndexPath) -> SettingsModel? {
        return self.settings?[index.row]
    }
    
    func popupToChangeLang() {
        coordinator?.present(MainDestination.changeLang)
    }
    
    func didSelectPages(at index: IndexPath) {
        let pageId = settings?[index.row].id
        coordinator?.navigateTo(MainDestination.page(pageId!))
    }
    
    func navigateToContactUs(){
        coordinator?.navigateTo(MainDestination.contactUs(contactInfo!))
    }
    
    func goToNotification() {
        coordinator?.navigateTo(MainDestination.notifications)
    }
}

// MARK: - VM Protocol

protocol SettingsVMProtocol: ViewModel {
    var contactInfo: ContactInfoModel? {get set}
    var numberOfSettings: Int? { get }
    var notificationIsOn: Observable<Bool> { get set }
    var contactInfoo: ContactInfoModel? {get}
    func viewDidLoad()
    func dequeCellForRow(at index: IndexPath) -> SettingsModel?
    func popupToChangeLang()
    func didSelectPages(at index: IndexPath)
    func navigateToContactUs()
    func goToNotification()
}
