//
//  RepoResultCell.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import UIKit
import SDWebImage

protocol RepoResultCellProtocol {
    func configure()
}

class RepoResultCell: UITableViewCell, RepoResultCellProtocol {
    
    // - MARK: Static Properties
    
    static let cellIdentifier = "RepoResultCell"
    static let nibName = cellIdentifier
    
    // - MARK: IBOutlets

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var starsLabel: UILabel!
    
    // - MARK: Properties
    
    var viewModel: RepoResultCellViewModel! {
        didSet {
            configure()
        }
    }
    
    // - MARK: Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftImageView.layer.cornerRadius = 10
        leftImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        authorLabel.text = nil
        starsLabel.text = nil
        leftImageView.image = nil
    }
    
    static func nib() -> UINib {
        return UINib(nibName: RepoResultCell.nibName, bundle: nil)
    }
    
    // - MARK: Delegate Methods for View Model
    
    func configure() {
        prepareForReuse()
        titleLabel.text = viewModel.repository.name
        authorLabel.text = viewModel.repository.authorName
        starsLabel.text = String(format: "%d", locale: Locale.current, viewModel.repository.stargazerCount)
        leftImageView.sd_setImage(with: viewModel.repository.authorAvatarImageUrl)
    }
    
}
