//
//  PickerViewTextField.swift


import UIKit
import IQKeyboardManagerSwift

protocol PickerNameDescription {
    var pickerName: String { get }
}

@IBDesignable
class PickerViewTextField: BaseTextField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
//    lazy var textField: MainTextField = {
//        let view = MainTextField()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    private var selectedRow = 0
    
    var didSelectItem: ((Any) -> ())?
    var didSelectItemAtRow: ((Int) -> ())?

    
    var items = [CustomStringConvertible]() {
        didSet {
//            selectedRow = 0
            pickerView.reloadAllComponents()
            if isFirstResponder == true {
                pickerView(pickerView, didSelectRow: selectedRow, inComponent: 0)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPicker()
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPicker()
        self.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPicker()
        self.delegate = self
    }
    
    private func setupPicker() {
        self.inputView = pickerView
//        self.addCancelDoneOnKeyboardWithTarget(self,
//                                               cancelAction: #selector(dismissBtnTapped),
//                                               doneAction: #selector(doneBtnTapped))
        
        let invocation = IQInvocation(self, #selector(doneBtnTapped))
        self.keyboardToolbar.doneBarButton.invocation = invocation
    }
    
    @objc func dismissBtnTapped(){
        self.delegate = nil
        self.resignFirstResponder()
    }
    
    
    @objc func doneBtnTapped(){
        self.endEditing(true)
        if !items.isEmpty {
            self.text = self.items[selectedRow].description
            didSelectItemAtRow?(selectedRow)
        }
    }
    
    func reloadData() {
        pickerView.reloadAllComponents()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return String(describing: items[row])
        return items[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard items.count > 0 else { return }
        selectedRow = row
//        textField.text = String(describing: items[row])
//        self.text = items[row].description
//        didSelectItem?(items[row])
//        didSelectItemAtRow?(row)
    }
    
     func textFieldDidBeginEditing(_ textField: UITextField) {
//        super.textFieldDidBeginEditing(textField)
//        pickerView(pickerView, didSelectRow: selectedRow, inComponent: 0)
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        pickerView(pickerView, didSelectRow: selectedRow, inComponent: 0)
        if !items.isEmpty {
//            didSelectItem?(items[selectedRow])
        self.text = items[selectedRow].description
        }
    }
    
    func setSelectedItem<T: CustomStringConvertible>(_ item: T) {
        guard let selectedItem = items.first(where: { ($0 as AnyObject).description == item.description }) else { return }
        selectedRow = items.firstIndex(where: { ($0 as AnyObject).description == (selectedItem as AnyObject).description }) ?? 0
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        pickerView(pickerView, didSelectRow: selectedRow, inComponent: 0)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
}
