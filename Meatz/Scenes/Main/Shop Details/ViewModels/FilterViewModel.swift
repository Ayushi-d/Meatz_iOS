//
//  FilterViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import Foundation

final class FilterViewModel : FilterVMProtocol{
    private var options : [CategoryModel] = []
    private var selectedOptions : [CategoryModel] = []
    var didSelectOption : (([CategoryModel]) -> Void)?
    
    init(_ options: [CategoryModel], _ selectedOptions : [CategoryModel]) {
        self.options = options
        self.selectedOptions = selectedOptions
    }
    var numberOfOptions: Int{
        return options.count
    }
    
    func didSelectItem(at index : Int) {
        let option = options[index]
        guard !selectedOptions.contains(option) else{return}
        selectedOptions.append(options[index])
    }
    
    func didDeSelectItem(at index: Int) {
        selectedOptions.removeAll(where: {$0.id == options[index].id})
    }
    func optionForCell(at index : Int) -> FilterViewModel.Option {
        return Option(options[index])
    }
    
    func didFinishPickingOptions() {
        guard let onSelection = didSelectOption else{return}
        onSelection(selectedOptions)
    }
    
    func isSelected(at index: Int) -> Bool {
        return selectedOptions.contains(options[index])
    }
    struct Option : FilterTableViewCellViewModel{
        let option : CategoryModel
        init(_ option : CategoryModel) {
            self.option = option
        }
        
        var optionTitle: String{
            return option.name
        }
    }
}


protocol FilterVMProtocol {
    var numberOfOptions : Int{get}
    func didFinishPickingOptions()
    func didSelectItem(at index : Int)
    func didDeSelectItem(at index : Int)
    func optionForCell(at index : Int) -> FilterViewModel.Option
    func isSelected(at index : Int ) -> Bool
}
