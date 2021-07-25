//
//  RepoResultCellViewModel.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/25/21.
//

import Foundation

class RepoResultCellViewModel {
    
    // - MARK: Properties
    
    private var delegate: RepoResultCellProtocol!
    
    private(set) var repository: Repository! {
        didSet {
            delegate.configure()
        }
    }
    
    // - MARK: Initializers
    
    init(with repository: Repository, delegate: RepoResultCellProtocol) {
        self.delegate = delegate
        self.repository = repository
    }
}
