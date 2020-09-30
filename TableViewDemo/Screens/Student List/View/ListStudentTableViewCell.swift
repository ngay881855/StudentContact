//
//  ListStudentTableViewCell.swift
//  TableViewDemo
//
//  Created by Ngay Vong on 9/18/20.
//

import UIKit

class ListStudentTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contactImageView: UIImageView!
    
    @IBOutlet weak var favorButton: UIButton!
    
    // MARK: - View Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contactImageView.layer.masksToBounds = true
        contactImageView.layer.cornerRadius = contactImageView.bounds.width/2
        contactImageView.layer.borderWidth = 1
        contactImageView.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
