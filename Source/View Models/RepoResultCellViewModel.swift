//
//  RepoResultCellViewModel.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/25/21.
//

import Foundation

class RepoResultCellViewModel {
    
    // - MARK: Datasource
    
    private(set) var repository: Repository!
    
    // - MARK: Properties
    
    var subtitle: String {
        return repository.authorName
    }
    
    var title: String {
        return repository.name
    }
    
    var imageUrl: URL {
        URL(string: repository.authorAvatarImageUrl)!
    }
    
    var disclosure: String {
        return String(format: "%d", locale: Locale.current, repository.stargazerCount)
    }
    
    // - MARK: Initializers
    
    init(with repository: Repository) {
        self.repository = repository
    }
}
