//
//  AddEditStudentTableViewCell.swift
//  Q20
//
//  Created by Ngay Vong on 9/20/20.
//

import UIKit

protocol AddEditStudentTextUpdate {
    func updateTextFieldValue(value: String, keyType: StudentInfoKey)
}

class AddEditStudentTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    // MARK: - Properties
    var keyType: StudentInfoKey = StudentInfoKey.firstName
    var textFieldDelegate: AddEditStudentTextUpdate?
    var previousText: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - UISetup/Helpers/Actions
    @IBAction func textFieldEditingDidBegin(_ sender: Any) {
        let textField = sender as? UITextField
        if let text = textField?.text {
            previousText = text
        }
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        let textField = sender as? UITextField
        if let text = textField?.text, text.count > 0 {
            switch keyLabel.text {
            case StudentInfoKey.firstName.rawValue, StudentInfoKey.lastName.rawValue:
                if text.count > 25 || !text.isAlphanumeric{
                    valueTextField.text = previousText
                } else {
                    previousText = text
                }
            case StudentInfoKey.phone.rawValue:
                if text.count > 12 || !text.isPhoneNumberCharacter {
                    valueTextField.text = previousText
                } else {
                    previousText = text
                }
            case StudentInfoKey.email.rawValue:
                if text.count > 50 {
                    valueTextField.text = previousText
                } else {
                    previousText = text
                }
            default:
                break
            }
            textFieldDelegate?.updateTextFieldValue(value: previousText ?? "", keyType: self.keyType)
        } else {
            previousText = nil
        }
    }
}
