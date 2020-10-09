//
//  AddEditStudentViewController.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/20/20.
//

import UIKit

protocol StudentInformationDelegate: class {
    func updateData(student: Student, sender: Any?)
}

class AddEditStudentViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var studentTableView: UITableView!
    @IBOutlet weak var myNavigationBar: UINavigationBar!
    
    // MARK: - Properties
    var student: Student = Student()
    var studentInfos: [StudentInfo] = []
    weak var delegate: StudentInformationDelegate?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        loadData()
    }
    
    // MARK: - UISetup/ Helpers
    private func setupUI() {
        self.title = "Student Details"
        studentTableView.tableFooterView = UIView()
        // if the delegate of this VC is StudentDetailVC, then the title is Edit, otherwise, the title is Add
        self.myNavigationBar.topItem?.title = self.delegate is StudentDetailViewController ? Constant.editStudentTitle : Constant.addStudentTitle
        
        profileButton.layer.masksToBounds = true
        profileButton.layer.cornerRadius = profileButton.bounds.width/2
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imageVC = UIImagePickerController()
        imageVC.delegate = self
        imageVC.allowsEditing = true
        imageVC.sourceType = sourceType
        self.present(imageVC, animated: true, completion: nil)
    }
    
    private func loadData() {
        // Load data into table view INFO
        var info = StudentInfo(key: StudentInfoKey.firstName.rawValue, value: student.firstName, keyType: StudentInfoKey.firstName)
        studentInfos.append(info)
        info = StudentInfo(key: StudentInfoKey.lastName.rawValue, value: student.lastName, keyType: StudentInfoKey.lastName)
        studentInfos.append(info)
        info = StudentInfo(key: StudentInfoKey.phone.rawValue, value: student.phoneNumber, keyType: StudentInfoKey.phone)
        studentInfos.append(info)
        info = StudentInfo(key: StudentInfoKey.email.rawValue, value: student.email, keyType: StudentInfoKey.email)
        studentInfos.append(info)
        
        profileButton.setImage(student.profileImage, for: .normal)
    }

    // MARK: - Actions
    @IBAction func tapGestureActivated(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func cancelBarButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBarButton(_ sender: Any) {
        var studentTemp = student
        
        studentTemp.profileImage = profileButton.currentImage ?? #imageLiteral(resourceName: "defaultProfile")
        
        var message = String()
        var title = String()
        if !studentTemp.firstName.validateName() {
            title = "Invalid first name"
            message = "First name can only contain alphabet characters and numbers, and has to be between 3 and 25 characters"
        } else if !studentTemp.lastName.validateName() {
            title = "Invalid last name"
            message = "Last name can only contain alphabet characters and numbers, and has to be between 3 and 25 characters"
        } else if !studentTemp.phoneNumber.validatePhoneNumber() {
            title = "Invalid phone number"
            message = "Phone number can have only numbers, and the length must be between 10 to 12 characters"
        } else if !studentTemp.email.validateEmailId() {
            title = "Invalid email"
            message = "Please make sure email is in correct format (ex: david@gmail.com), and the length must not greater than 50 characters"
        }
        if !title.isEmpty && !message.isEmpty {
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil      )
            alert.addAction(actionOK)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.student = studentTemp
            self.delegate?.updateData(student: self.student, sender: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func profileButton(_ sender: Any) {
        let actionSheet: UIAlertController = UIAlertController(title: "Please select where you want to choose photo from", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showImagePicker(sourceType: .camera)
        }
        actionCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        let actionPhotoLibrary = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(actionCamera)
        actionSheet.addAction(actionPhotoLibrary)
        actionSheet.addAction(actionCancel)
        // On iPad, action sheets must be presented from a popover.
        actionSheet.popoverPresentationController?.barButtonItem =
            self.myNavigationBar.topItem?.leftBarButtonItem
        self.present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension AddEditStudentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension AddEditStudentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studentInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddEditStudentTableViewCell", for: indexPath) as? AddEditStudentTableViewCell else {
            fatalError("Can not create cell")
        }
        cell.keyLabel.text = studentInfos[indexPath.row].key
        cell.valueTextField.text = studentInfos[indexPath.row].value
        cell.keyType = studentInfos[indexPath.row].keyType
        cell.textFieldDelegate = self
        switch studentInfos[indexPath.row].keyType {
        case StudentInfoKey.firstName, StudentInfoKey.lastName:
            cell.valueTextField.keyboardType = .default
            cell.valueTextField.autocapitalizationType = .words
        case StudentInfoKey.phone:
            cell.valueTextField.keyboardType = .phonePad
        case StudentInfoKey.email:
            cell.valueTextField.keyboardType = .emailAddress
        }
        return cell
    }
}

extension AddEditStudentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.profileButton.setImage(image, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddEditStudentViewController: AddEditStudentTextUpdate {
    func updateTextFieldValue(value: String, keyType: StudentInfoKey) {
        switch keyType {
        case .firstName:
            student.firstName = value
        case .lastName:
            student.lastName = value
        case .phone:
            student.phoneNumber = value
        case .email:
            student.email = value
        }
    }
}
