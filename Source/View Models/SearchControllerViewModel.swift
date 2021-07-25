//
//  SearchViewModel.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/25/21.
//

import UIKit
import Apollo

class SearchControllerViewModel {
    
    // - MARK: Properties
    
    private var delegate: SearchControllerProtocol!
    private var client: ApolloClient!
    
    private var searchResults = [Repository]()
    private var searchQuery: String! {
        delegate.searchBar.text
    }
    private var cursorPosition: String!
    
    private(set) var isMoreDataLoading = false
    
    // - MARK: Initializers
    
    init(delegate: SearchControllerProtocol) {
        self.delegate = delegate
    }
    
    // - MARK: TableView Datasource
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return searchResults.count
    }
    
    func cellForRowAtIndexPath(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoResultCell.cellIdentifier) as! RepoResultCell
        cell.viewModel = RepoResultCellViewModel(with: searchResults[indexPath.row], delegate: cell)
        return cell
    }
    
    // - MARK: Methods for Controller
    
    func willClearTableView() {
        searchResults.removeAll()
        cursorPosition = nil
    }
    
    func fetchMoreRepositories() {
        fetchRepositories(afterCursor: cursorPosition)
    }

    func fetchRepositories(afterCursor: String? = nil) {
        isMoreDataLoading = true
        delegate.didStartLoading()
        
        Network.shared.apollo
            .fetch(query: SearchQuery(query: searchQuery, limit: 25, afterCursor: afterCursor)) { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            defer {
                self.isMoreDataLoading = false
                self.delegate.didEndLoading()
            }
            
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data,
                   let repositoryConnection = data.search.edges,
                   let endCursor = data.search.pageInfo.endCursor {
                    self.cursorPosition = endCursor
                    let newResults = repositoryConnection.compactMap { Repository(from: $0!.node!.asRepository!) }
                    self.searchResults.append(contentsOf: newResults)
                }
                
                if let errors = graphQLResult.errors {
                    fatalError("Failure! Error: \(errors.compactMap{$0.localizedDescription})")
                }
            case .failure(let error):
                fatalError("Failure! Error: \(error)")
            }
        }
    }
}
