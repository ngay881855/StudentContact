//
//  StudentDetailsTableViewCell.swift
//  StudentContact
//
//  Created by Ngay Vong on 9/20/20.
//

import UIKit

class StudentDetailsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI(key: String, value: String) {
        self.keyLabel.text = key
        self.valueLabel.text = value
    }
}
