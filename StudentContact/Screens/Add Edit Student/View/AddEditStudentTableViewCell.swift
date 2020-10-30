//
//  AddEditStudentTableViewCell.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/20/20.
//

import UIKit

protocol AddEditStudentTextUpdate: AnyObject {
    func updateTextFieldValue(value: String, keyType: StudentInfoKey)
}

class AddEditStudentTableViewCell: UITableViewCell, UITextFieldDelegate {
    // MARK: - IBOutlets
    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueTextField: UITextField!
    
    // MARK: - Properties
    var keyType = StudentInfoKey.firstName
    weak var textFieldDelegate: AddEditStudentTextUpdate?
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
    
    #warning("Doesn't support iOS 12.0, have to rework on this")
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            switch self.keyType {
            case StudentInfoKey.firstName, StudentInfoKey.lastName:
                if text.count > Constants.maxNameLength || !text.isAlphanumeric {
                    valueTextField.text = previousText
                } else {
                    previousText = text
                }
                
            case StudentInfoKey.phone:
                if text.count > Constants.maxPhoneNumberLength || !text.isPhoneNumberCharacter {
                    valueTextField.text = previousText
                } else {
                    previousText = text
                }
                
            case StudentInfoKey.email:
                if text.count > Constants.maxEmailLength {
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
    
    func setupUI(studentInfo: StudentInfo) {
        self.keyLabel.text = studentInfo.key
        self.valueTextField.text = studentInfo.value
        self.keyType = studentInfo.keyType
        
        switch self.keyType {
        case StudentInfoKey.firstName, StudentInfoKey.lastName:
            self.valueTextField.keyboardType = .default
            self.valueTextField.autocapitalizationType = .words
            
        case StudentInfoKey.phone:
            self.valueTextField.keyboardType = .phonePad
            
        case StudentInfoKey.email:
            self.valueTextField.keyboardType = .emailAddress
        }
    }
}
