//
//  SearchViewModel.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import Foundation

class SearchViewModel {
    var reloadTableViewClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    
    private var cellViewModels = [RepoResultCellModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    func getCellViewModel( at indexPath: IndexPath ) -> RepoResultCellModel {
        return cellViewModels[indexPath.row]
    }

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    func initFetch() {
        self.isLoading = true
        // fetch data
        self.isLoading = false
    }
    
}
