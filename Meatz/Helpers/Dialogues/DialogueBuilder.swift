//
//  DialogueBuilder.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/23/21.
//

import Foundation
import UIKit

final class DialogueBuilder {
    
    private var view : OneActionDialogue
    
    init() {
        view = OneActionDialogue()
    }
    
    func title(_ text : String) -> DialogueBuilder{
        view.title = text
        return self
    }
    
    func message(_ text : String) -> DialogueBuilder{
        view.message = text
        return self
    }
    
    func action(_ title : String,_ action : @escaping () -> Void) -> DialogueBuilder{
        view.action = action
        view.actionTitle = title
        return self
    }
    
    func dismissAction(_ action : (() -> Void)?) -> DialogueBuilder{
        view.dimissAction = action
        return self
    }
    
    func build() -> OneActionDialogue{
        return view 
    }
    
}
