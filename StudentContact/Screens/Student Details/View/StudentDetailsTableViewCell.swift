//
//  StudentDetailsTableViewCell.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/20/20.
//

import UIKit

class StudentDetailsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
