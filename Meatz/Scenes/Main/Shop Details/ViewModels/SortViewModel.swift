//
//  SortViewModel.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/29/21.
//

import Foundation

final class SortViewModel : SortVMProtocol{
    
    private var selectedOption : SortOption?
    private var options : [SortOption] = [.latest,.low_price,.high_price]
    var didSelectOption : ((_ option : SortOption)->Void)?
    var numberOfIndex:Int = 0
    var numberOfOptions: Int{
        return options.count
    }
    
    init(_ selectedOption : SortOption?) {
        self.selectedOption = selectedOption
    }
    func didSelectItem(_ completion : ()->Void) {
        guard let onSelection = didSelectOption else{return}
        onSelection(options[numberOfIndex])
        completion()
    }
    
    func optionForCell(at index : Int) -> SortViewModel.Option {
        return Option(options[index])
    }
    
    func isSelected(at index: Int) -> Bool {
        return options[index].rawValue == (selectedOption?.rawValue ?? "")
    }
    struct Option : SortTableViewCellViewModel{
        let option : SortOption
        init(_ option : SortOption) {
            self.option = option
        }
        
        var titleString: String{
            return option.title
        }
        
        
    }
}




protocol SortVMProtocol {
    var numberOfOptions : Int{get}
    var numberOfIndex:Int {get set}

    func didSelectItem(_ completion : ()->Void)
    func optionForCell(at index : Int) -> SortViewModel.Option
    func isSelected(at index : Int) -> Bool
}
