
import UIKit

class DropDownPicker: UIControl {
  fileprivate let picker: UIPickerView = UIPickerView()
  fileprivate let toolbar: UIToolbar = UIToolbar()

  var textfield: UITextField!

  var data: Array<String> = []

  var placeholder: String = "Tap to choose ..." {
    didSet { textfield.placeholder = placeholder }
  }
  var placeholderWhileSelecting: String? = "Pick an option ..."

  var selectedIndex: Int? {
    get {
      if let text = textfield.text {
        return data.index(of: text)
      }
      return nil
    }
    set {
      if newValue == nil  {
        textfield.text = nil
        textfield.placeholder = placeholder
      } else {
        pickerView(self.picker, didSelectRow: newValue!, inComponent: 0)
      }
    }
  }

  fileprivate var hasValidSelection: Bool {
    if let text = textfield.text {
      return data.contains(text)
    }
    return false
  }

  fileprivate var previousSelection: String? = nil
  fileprivate var hasValidPreviousSelection: Bool {
    if let previousSelection = previousSelection {
      return data.contains(previousSelection)
    }
    return false
  }

  public init(frame: CGRect, textfield: UITextField,
              data: Array<String>? = nil) {
    super.init(frame: frame)

    self.textfield = textfield
    self.textfield.delegate = self
    self.textfield.placeholder = placeholder
    (self.textfield.value(forKey: "textInputTraits") as! NSObject)
        .setValue(UIColor.clear, forKey: "insertionPointColor")

    self.picker.showsSelectionIndicator = true
    self.picker.dataSource = self
    self.picker.delegate = self

    self.toolbar.sizeToFit()

    let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                 action: #selector(cancelClicked(_:)))
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil,
                                action: nil)
    let done = UIBarButtonItem(title: "Done", style: .done, target: self,
                               action: #selector(doneClicked(_:)))

    self.toolbar.setItems([cancel, space, done], animated: false)

    if let data = data {
      self.data = data
    }
  }

  public convenience init(textfield: UITextField, data: Array<String>? = nil) {
    self.init(frame: CGRect.zero, textfield: textfield, data: data)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc
  private func doneClicked(_ sender: Any) {
    textfield.resignFirstResponder()

    if !hasValidSelection {
      selectedIndex = nil
    }

    sendActions(for: .valueChanged)
  }

  @objc
  private func cancelClicked(_ sender: Any) {
    textfield.resignFirstResponder()
    if hasValidPreviousSelection {
      textfield.text = previousSelection!
    } else {
      selectedIndex = nil
    }
  }
}

extension DropDownPicker: UITextFieldDelegate {
  private func showPicker() {
    previousSelection = textfield.text

    if !hasValidSelection {
      if (placeholderWhileSelecting != nil) {
        textfield.placeholder = placeholderWhileSelecting
      }
      selectedIndex = 0
    } else {
      if let text = textfield.text {
        if data.contains(text) {
          picker.selectRow((data.index(of: text))!, inComponent: 0,
                           animated: true)
        }
      }
    }

    textfield.inputView = picker
    textfield.inputAccessoryView = toolbar
  }

  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if data.count > 0 {
      showPicker()
      return true
    }
    return false
  }

  public func textFieldDidBeginEditing(_ textField: UITextField) {
    sendActions(for: .editingDidBegin)
  }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    textField.isUserInteractionEnabled = true
    sendActions(for: .editingDidEnd)
  }

  public func textField(_ textField: UITextField,
                        shouldChangeCharactersIn range: NSRange,
                        replacementString string: String) -> Bool {
    return false
  }
}

extension DropDownPicker: UIPickerViewDelegate {
  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                         forComponent component: Int) -> String? {
    guard row >= 0 && row < data.count else { return nil }

    return data[row]
  }

  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                         inComponent component: Int) {
    guard row >= 0 && row < data.count else { return }

    textfield.text = data[row]
    sendActions(for: .valueChanged)
  }
}

extension DropDownPicker: UIPickerViewDataSource {
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  public func pickerView(_ pickerView: UIPickerView,
                         numberOfRowsInComponent component: Int) -> Int {
    return data.count
  }
}

class DropDownPickerView: UITextField {
  var inset: UIEdgeInsets = UIEdgeInsets()

  private var picker: DropDownPicker!

  var selection: Int? {
    get { return picker.selectedIndex }
    set { picker.selectedIndex = newValue }
  }

  public init(frame: CGRect, data: Array<String>) {
    super.init(frame: frame)

    picker = DropDownPicker(textfield: self, data: data)
  }

  public convenience init(data: Array<String>) {
    self.init(frame: CGRect.null, data: data)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, inset)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, inset)
  }
}

