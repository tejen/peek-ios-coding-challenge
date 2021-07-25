//
//  SearchViewController.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var repositories = [SearchQuery.Data.Search.Edge.Node.AsRepository]()
    private var cursorPosition: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(RepoResultCell.nib(), forCellReuseIdentifier: RepoResultCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        // prepare ui state before initial Loading animation
        tableView.alpha = 0
        activityIndicator.alpha = 0
        
        
        fetchRepositories()
    }

    func fetchRepositories(afterCursor: String? = nil) {
        didStartLoading()
        
        Network.shared.apollo
            .fetch(query: SearchQuery(query: "graphql", limit: 25, afterCursor: afterCursor)) { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            defer {
                self.tableView.reloadData()
                self.didEndLoading()
            }
            
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data,
                   let repositoryConnection = data.search.edges,
                   let endCursor = data.search.pageInfo.endCursor {
                    self.cursorPosition = endCursor
                    self.repositories.append(contentsOf: repositoryConnection.compactMap { $0?.node?.asRepository })
                }
                
                if let errors = graphQLResult.errors {
                    fatalError("Failure! Error: \(errors.compactMap{$0.localizedDescription})")
                }
            case .failure(let error):
                fatalError("Failure! Error: \(error)")
            }
        }
    }
    
    // - MARK: UI Helper Methods
    
    func didStartLoading() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2) { [self] in
            activityIndicator.alpha = 1
        }
    }
    
    func didEndLoading() {
        UIView.animate(withDuration: 0.2) { [self] in
            activityIndicator.alpha = 0
            tableView.alpha = 1
        } completion: { [self] _ in
            activityIndicator.stopAnimating()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // - MARK: TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoResultCell.cellIdentifier) as! RepoResultCell
        cell.repository = repositories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // ** tableview is preparing to display its last row **
        
        // load more results into the end of the tableview, to allow for infinite scrolling
        if indexPath.row + 1 == self.repositories.count {
            fetchRepositories(afterCursor: cursorPosition)
        }
    }
    
}
