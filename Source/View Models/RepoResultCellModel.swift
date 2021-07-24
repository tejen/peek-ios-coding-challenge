//
//  RepoResultCellModel.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import UIKit

struct RepoResultCellModel {
    
    let name: String
    
    init(with repository: Repository) {
        name = repository.name
    }
    
}
