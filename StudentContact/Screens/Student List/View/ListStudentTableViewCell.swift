//
//  ListStudentTableViewCell.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/18/20.
//

import UIKit

class ListStudentTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    
    @IBOutlet private weak var contactImageView: UIImageView!
    
    @IBOutlet private weak var favorButton: UIButton!
    
    // MARK: - View Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contactImageView.layer.masksToBounds = true
        contactImageView.layer.cornerRadius = contactImageView.bounds.width / 2
        contactImageView.layer.borderWidth = 1
        contactImageView.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(studentInfo student: Student) {
        self.nameLabel.text = student.firstName + " " + student.lastName
        self.contactImageView.image = student.profileImage
        self.favorButton.setImage(student.isFavorite ? UIImage(imageLiteralResourceName: "favorite") : UIImage(imageLiteralResourceName: "unfavorite"), for: .normal)
    }
}
