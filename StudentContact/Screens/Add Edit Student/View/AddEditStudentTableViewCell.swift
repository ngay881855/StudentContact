//
//  AddEditStudentTableViewCell.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/20/20.
//

import UIKit

protocol AddEditStudentTextUpdate {
    func updateTextFieldValue(value: String, keyType: StudentInfoKey)
}

class AddEditStudentTableViewCell: UITableViewCell, UITextFieldDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    // MARK: - Properties
    var keyType: StudentInfoKey = StudentInfoKey.firstName
    var textFieldDelegate: AddEditStudentTextUpdate?
    private var previousText: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.valueTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        previousText = textField.text
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, text.count > 0 {
            switch self.keyType {
            case StudentInfoKey.firstName, StudentInfoKey.lastName:
                if text.count > Constant.maxNameLength || !text.isAlphanumeric{
                    valueTextField.text = previousText
                } else {
                    previousText = text
                }
            case StudentInfoKey.phone:
                if text.count > Constant.maxPhoneNumberLength || !text.isPhoneNumberCharacter {
                    valueTextField.text = previousText
                } else {
                    previousText = text
                }
            case StudentInfoKey.email:
                if text.count > Constant.maxEmailLength {
                    valueTextField.text = previousText
                } else {
                    previousText = text
                }
            }
        } else {
            previousText = nil
        }
        
        textFieldDelegate?.updateTextFieldValue(value: previousText ?? "", keyType: self.keyType)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
