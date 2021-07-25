//
//  RepoResultCell.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import UIKit
import SDWebImage

class RepoResultCell: UITableViewCell {
    
    static let cellIdentifier = "RepoResultCell"
    static let nibName = cellIdentifier

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var starsLabel: UILabel!
    
    var repository: SearchQuery.Data.Search.Edge.Node.AsRepository! {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftImageView.layer.cornerRadius = 10
        leftImageView.clipsToBounds = true
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
        starsLabel.text = String(describing: repository.stargazerCount)
        leftImageView.sd_setImage(with: URL(string: repository.owner.avatarUrl))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        authorLabel.text = nil
        starsLabel.text = nil
        leftImageView.image = nil
    }
    
}
