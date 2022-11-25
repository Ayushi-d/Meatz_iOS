//
//  BoxesViewModel.swift
//  Meatz
//
//  Created by Nabil Elsherbene on 4/14/21.
//

import Foundation

final class MyBoxesViewModel {
    private var repo: MyBoxesRepoProtocol?
    var coordinator: Coordinator?
    private var myBoxes: [BoxesDataModel] = []
    var onRequestCompletion: ((String?) -> Void)?
    var requestError: Observable<ResultError>? = Observable(nil)
    var state: State = .notStarted

    init(repo: MyBoxesRepoProtocol?, _ coordinator: Coordinator?) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

// MARK: - Request

extension MyBoxesViewModel {
    func viewDidLoad() {
        self.repo?.didRecieveBoxes { [weak self] result in
            guard let self = self else { return }
            self.responseHandeler(result)
        }
    }
}

// MARK: - Handel Response

extension MyBoxesViewModel {
    private func responseHandeler(_ result: Result<MyBoxesModel, ResultError>) {
        switch result {
        case .success(let model):
            self.myBoxes = model.boxes
            guard let completion = self.onRequestCompletion else { return }
            completion(model.message)
        case .failure(let error):
            self.requestError?.value = error
        }
    }
}

// MARK: - VMImpl

extension MyBoxesViewModel: MyBoxesVMProtocol {
    var numberOfBoxes: Int {
        return self.myBoxes.count
    }

    func dequeCellForRow(at index: IndexPath) -> BoxesDataModel {
        return self.myBoxes[index.row]
    }

    func deleteBox(at indexPath: IndexPath) {
        let boxId = self.myBoxes[indexPath.row].id
        self.repo?.deletBox(with: boxId) { [weak self] result in
            guard let self = self else { return }
            self.responseHandeler(result)
        }
    }

    func addToCart(at indexPath: IndexPath) {
        let boxId = self.myBoxes[indexPath.row].id
        self.repo?.addToCart(with: boxId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let completion = self.onRequestCompletion else { return }
                completion(model.message)
            case .failure(let error):
                self.requestError?.value = error
            }
        }
    }

    func navigateToBoxDetails(with indexPath: IndexPath) {
        let boxId = self.myBoxes[indexPath.row].id
        self.coordinator?.navigateTo(MainDestination.boxProducts(boxId))
    }
    
    func navigateToCreateBox() {
        coordinator?.navigateTo(MainDestination.createBox)
    }
    func goToNotification() {
        coordinator?.navigateTo(MainDestination.notifications)
    }
}

// MARK: - VM Protocol

protocol MyBoxesVMProtocol: ViewModel {
    var coordinator: Coordinator?{get set}
    var numberOfBoxes: Int { get }
    func viewDidLoad()
    func dequeCellForRow(at index: IndexPath) -> BoxesDataModel
    func deleteBox(at indexPath: IndexPath)
    func addToCart(at indexPath: IndexPath)
    func navigateToBoxDetails(with indexPath: IndexPath)
    func navigateToCreateBox()
    func goToNotification()
}
