//
//  ListStudentsViewController.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/17/20.
//

import UIKit

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as? CAGradientLayer
        gradientLayer?.colors = [UIColor.white.cgColor, UIColor.green.cgColor]
    }
}

class ListStudentsViewController: UITableViewController {
    
    // MARK: Properties
    private var studentDataSource = StudentDataSource(section: [], dataSource: [:]) {
        didSet {
            if studentDataSource.section.isEmpty {
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
        
        self.loadDataFromDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // if there is no student in the list, ask the user to add one
        if studentDataSource.section.isEmpty {
            showAlertEmptyStudentList()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ViewControllerIdentifier.addEditStudentViewController {
            if let addEditViewController = segue.destination as? AddEditStudentViewController {
                addEditViewController.student = Student()
                addEditViewController.delegate = self
            }
        } else if segue.identifier == ViewControllerIdentifier.studentDetailViewController {
            if let studentDetailViewController = segue.destination as? StudentDetailViewController {
                guard let student = sender as? Student else { return }
                studentDetailViewController.student = student
                studentDetailViewController.studentDelegate = self
            }
        }
    }
    
    // MARK: Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        studentDataSource.section.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionName = studentDataSource.section[indexPath.section]
        let student = studentDataSource.dataSource[sectionName]?[indexPath.row] ?? Student()
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let studentDetailVC = storyboard.instantiateViewController(identifier: ViewControllerIdentifier.studentDetailViewController) as StudentDetailViewController
            studentDetailVC.student = student
            studentDetailVC.studentDelegate = self
            self.navigationController?.pushViewController(studentDetailVC, animated: true)
        } else {
            self.performSegue(withIdentifier: ViewControllerIdentifier.studentDetailViewController, sender: student)
        }
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
        if let student = studentDataSource.dataSource[sectionName]?[indexPath.row] {
            cell.setupUI(studentInfo: student)
        }
        
        return cell
    }
    
    // MARK: - UISetup/ Helpers/ Actions
    @IBAction private func addStudentButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let addStudentVC = storyboard.instantiateViewController(identifier: ViewControllerIdentifier.addEditStudentViewController) as AddEditStudentViewController
            addStudentVC.delegate = self
            addStudentVC.student = Student()
            self.present(addStudentVC, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: ViewControllerIdentifier.addEditStudentViewController, sender: Student())
        }
    }
    
    // swiftlint:disable discouraged_object_literal
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
    
    private func loadDataFromDataSource() {
        let studentDataAccess = StudentDataAccess()
        let students = studentDataAccess.getAllStudents()
        for student in students {
            self.addStudent(at: nil, student: student)
        }
    }
    
    private func addStudentToDB(student: Student) {
        do {
            let studentDataAccess = StudentDataAccess()
            try studentDataAccess.insert(student: student)
        } catch {
            print(error.localizedDescription)
        }
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
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            self.addStudentButtonTapped(self)
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
        if sender is StudentDetailViewController, let previousIndexPath = previousIndexPath {
            studentDataSource.dataSource[studentDataSource.section[previousIndexPath.section]]?.remove(at: previousIndexPath.row)
            if let section = studentDataSource.dataSource[studentDataSource.section[previousIndexPath.section]], section.isEmpty {
                studentDataSource.section.remove(at: previousIndexPath.section)
            }
        } else {
            addStudentToDB(student: student)
        }
        addStudent(at: nil, student: student)
        
        self.tableView.reloadData()
    }
}
