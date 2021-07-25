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

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    
    var repository: SearchQuery.Data.Search.Edge.Node.AsRepository! {
        didSet {
            configure()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: RepoResultCell.nibName, bundle: nil)
    }
    
    func configure() {
        prepareForReuse()
        authorLabel.text = repository.owner.login
        titleLabel.text = repository.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        authorLabel.text = nil
        leftImageView.image = nil
    }
    
}
