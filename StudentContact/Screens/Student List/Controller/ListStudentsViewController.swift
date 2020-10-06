//
//  ListStudentsViewController.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/17/20.
//

import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.green.cgColor]
    }
}

class ListStudentsViewController: UITableViewController {
    
    // MARK: Properties
    private var studentDataSource = StudentDataSource(section: [], dataSource: [:]) {
        didSet {
            if studentDataSource.section.count == 0 {
                showAlertEmptyStudentList()
            }
        }
    }
    
    private var previousIndexPath: IndexPath?
    
    // MARK: VIEW LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        self.title = "Students"
        
        loadDefaultData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // if there is no student in the list, ask the user to add one
        if studentDataSource.section.count == 0 {
            showAlertEmptyStudentList()
        }
    }
    
    // MARK: Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        studentDataSource.section.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let studentDetailVC = SB.instantiateViewController(identifier: "studentDetails") as StudentDetailViewController
        let sectionName = studentDataSource.section[indexPath.section]
        studentDetailVC.student = studentDataSource.dataSource[sectionName]?[indexPath.row] ?? Student()
        studentDetailVC.studentDelegate = self
        self.navigationController?.pushViewController(studentDetailVC, animated: true)
        previousIndexPath = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        studentDataSource.section
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        studentDataSource.section[section]
    }
    
    // MARK: Data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.studentDataSource.dataSource[studentDataSource.section[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ListStudentTableViewCell else {
            return UITableViewCell()
        }
        let sectionName = studentDataSource.section[indexPath.section]
        if let contact = studentDataSource.dataSource[sectionName]?[indexPath.row] {
            cell.nameLabel.text = contact.firstName + " " + contact.lastName
            cell.contactImageView.image = contact.profileImage
            cell.favorButton.setImage(contact.isFavorite ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "unfavorite"), for: .normal)
        }
        
        return cell
    }
    
    // MARK: - UISetup/ Helpers/ Actions
    @IBAction func addStudent(_ sender: Any) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let addStudentVC = SB.instantiateViewController(identifier: "addEditStudent") as AddEditStudentViewController
        addStudentVC.studentDelegate = self //ListStudentViewController
        addStudentVC.student = Student()
        self.present(addStudentVC, animated: true, completion: nil)
    }
    
    private func loadDefaultData() {
        var student = Student(profileImage: #imageLiteral(resourceName: "p4"), firstName: "David", lastName: "Wang", phoneNumber: "6788881155", email: "davewang123@gmail.com", isFavorite: false)
        addStudent(at: nil, student: student)
        student = Student(profileImage: #imageLiteral(resourceName: "p1"), firstName: "Angel", lastName: "Panama", phoneNumber: "4049291133", email: "angelPanama@gmail.com", isFavorite: false)
        addStudent(at: nil, student: student)
        student = Student(profileImage: #imageLiteral(resourceName: "p5"), firstName: "Tommy", lastName: "Hillier", phoneNumber: "6788332718", email: "tommyHillier23@gmail.com", isFavorite: true)
        addStudent(at: nil, student: student)
        student = Student(profileImage: #imageLiteral(resourceName: "p3"), firstName: "Anthony", lastName: "Tran", phoneNumber: "6773832838", email: "anthonytran123@gmail.com", isFavorite: false)
        addStudent(at: nil, student: student)
    }
    
    private func addStudent(at index: Int?, student: Student) {
        var char = String(student.firstName.first ?? Character(""))
        if char.isNumeric {
            char = "#"
        }
        if !studentDataSource.section.contains(char) {
            studentDataSource.section.append(char)
            studentDataSource.dataSource[char] = [student]
        } else {
            if let index = index {
                studentDataSource.dataSource[char]?[index] = student
            } else {
                studentDataSource.dataSource[char]?.append(student)
            }
        }
    }
    
    private func showAlertEmptyStudentList() {
        let alertController = UIAlertController(title: "No student in your list", message: "Would you like to add a new student?", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            self.addStudent(self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension ListStudentsViewController: StudentInformationDelegate {
    func updateData(student: Student, sender: Any?) {
        if let previousIndexPath = previousIndexPath {
            if sender is StudentDetailViewController {
                studentDataSource.dataSource[studentDataSource.section[previousIndexPath.section]]?.remove(at: previousIndexPath.row)
                if studentDataSource.dataSource[studentDataSource.section[previousIndexPath.section]]?.count == 0 {
                    studentDataSource.section.remove(at: previousIndexPath.section)
                }
            }
            addStudent(at: nil, student: student)
            
            self.tableView.reloadData()
        }
    }
}
