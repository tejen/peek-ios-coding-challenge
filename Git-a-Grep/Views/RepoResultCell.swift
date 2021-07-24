//
//  RepoResultCell.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import UIKit

class RepoResultCell: UITableViewCell {
    
    static let cellIdentifier = "RepoResultCell"
    static let nibName = cellIdentifier

    @IBOutlet weak var testLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: RepoResultCell.nibName, bundle: nil)
    }
    
}
