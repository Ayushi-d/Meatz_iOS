//
//  AddToBoxesViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 4/19/21.
//

import Foundation


final class AddToBoxesViewModel {
    var requestError: Observable<ResultError>? = Observable.init(nil)
    var onRequestCompletion: ((String?) -> Void)?
    var state: State = .notStarted
    private var boxes : [BoxesDataModel] = []
    private var repo : MyBoxesRepoProtocol?
    private var coordinator : Coordinator?
    private var selectedBoxes : [BoxesDataModel] = []
    var didSelectBoxes : (([BoxesDataModel]) -> Void)?
    
    init(_ repo : MyBoxesRepoProtocol?,_ coordinator : Coordinator? ) {
        self.repo = repo
        self.coordinator = coordinator
    }
}

extension AddToBoxesViewModel : AddToBoxesVMProtocol{
    var numberOfBoxes: Int{
        return boxes.count
    }
    
    func onViewDidload() {
        repo?.didRecieveBoxes({ [weak self](result) in
            guard let self = self else{return}
            switch result{
            case .success(let model):
                self.state = .success
                self.boxes = model.boxes
                guard let completion = self.onRequestCompletion else{return}
                completion("")
            case .failure(let error):
                self.state = .notStarted
                self.requestError?.value = error
            }
        })
    }
    
    func didSelectItem(at index : Int) {
        let box = boxes[index]
        guard !selectedBoxes.contains(where: {return $0.id == box.id}) else{return}
        selectedBoxes.append(box)
    }
    
    func didDeSelectItem(at index: Int) {
        selectedBoxes.removeAll(where: {$0.id == boxes[index].id})
    }
    
    func boxForCell(at index: Int) -> BoxesDataModel {
        return boxes[index]
    }
    func isSelected(at index: Int) -> Bool {
        return selectedBoxes.contains(where: {return $0.id == boxes[index].id})
    }
    
    func add() {
        guard let onSelection = didSelectBoxes else{return}
        onSelection(selectedBoxes)
        coordinator?.dismiss(false, nil)
    }
    func close() {
        coordinator?.dismiss(false, nil)
    }
    
    func addNewBox() {
        coordinator?.navigateTo(MainDestination.createBox)
    }
}
protocol AddToBoxesVMProtocol  : ViewModel{
    var numberOfBoxes : Int{get}
    
    func onViewDidload()
    func didSelectItem(at index : Int)
    func didDeSelectItem(at index : Int)
    func boxForCell(at index : Int) -> BoxesDataModel
    func isSelected(at index : Int ) -> Bool
    func add()
    func close()
    func addNewBox()
}
