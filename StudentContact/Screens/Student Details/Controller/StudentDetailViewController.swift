//
//  StudentDetailViewController.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/20/20.
//

import UIKit
import MessageUI

class StudentDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var student: Student = Student()
    private var studentInfos: [StudentInfo] = []
    var studentDelegate: StudentInformationDelegate?
    
    private struct StudentInfo {
        var key: String
        var value: String
    }
    
    // MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadData()
        setupUI()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editAddVC = segue.destination as? AddEditStudentViewController else { return }
        editAddVC.student = self.student
        editAddVC.title = "Edit Contact"
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - UISetup/ Helpers
    private func setupUI() {
        self.title = "Student Details"
        tableView.tableFooterView = UIView()
        
        profileButton.layer.masksToBounds = true
        profileButton.layer.cornerRadius = self.profileButton.bounds.height/2
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = UIColor.gray.cgColor
        profileButton.isUserInteractionEnabled = false
    }
    
    private func loadData() {
        studentInfos.removeAll()
        
        // Load data into table view INFO
        var info = StudentInfo(key: StudentInfoKey.phone.rawValue, value: student.phoneNumber)
        studentInfos.append(info)
        info = StudentInfo(key: "Email", value: student.email)
        studentInfos.append(info)
        
        nameLabel.text = student.firstName + " " + student.lastName
        profileButton.setImage(student.profileImage, for: .normal)
        self.tableView.reloadData()
    }
    
    
    // MARK: - Actions
    @IBAction func editStudent(_ sender: Any) {
        //self.performSegue(withIdentifier: "addEditStudent", sender: self.student)
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let studentDetailVC = SB.instantiateViewController(identifier: "addEditStudent") as AddEditStudentViewController
        studentDetailVC.student = self.student
        studentDetailVC.title = "Edit Contact"
        studentDetailVC.studentDelegate = self
        self.present(studentDetailVC, animated: true, completion: nil)
    }
    
    @IBAction func messageAction(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let messageController = MFMessageComposeViewController()
            messageController.recipients = ["\(student.phoneNumber)"]
            messageController.messageComposeDelegate = self
            self.present(messageController, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Can not send text message", message: "Please setup your iMessage before trying to send text message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func callAction(_ sender: Any) {
        if let phoneURL = NSURL(string: ("tel://" + student.phoneNumber)) {
            let alert = UIAlertController(title: ("Calling " + student.phoneNumber), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func emailAction(_ sender: Any) {
        guard MFMailComposeViewController.canSendMail() else { return }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([student.email])
        composeVC.mailComposeDelegate = self
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    
}

// MARK: - Extensions
extension StudentDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension StudentDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // for now, only 2 properties: phone # and email
        studentInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailsTableViewCell", for: indexPath) as? StudentDetailsTableViewCell else {
            fatalError("Can not create cell")
        }
        cell.keyLabel.text = studentInfos[indexPath.row].key
        cell.valueLabel.text = studentInfos[indexPath.row].value
        return cell
    }
}

extension StudentDetailViewController: StudentInformationDelegate {
    func updateData(student: Student, sender: Any?) {
        self.student = student
        self.studentDelegate?.updateData(student: student, sender: self)
        loadData()
    }
}

extension StudentDetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .failed:
            let alert = UIAlertController(title: "Sending email failed", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .sent:
            let alert = UIAlertController(title: "Successfully sent email", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            print("Default")
        }
    }
}

extension StudentDetailViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .failed:
            let alert = UIAlertController(title: "Sending message failed", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .sent:
            let alert = UIAlertController(title: "Successfully sent message", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            print("Default")
        }
    }
}
