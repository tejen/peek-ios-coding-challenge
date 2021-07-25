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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(RepoResultCell.nib(), forCellReuseIdentifier: RepoResultCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchRepositories()
    }

    func fetchRepositories() {
        activityIndicator.startAnimating()
        
        Network.shared.apollo
            .fetch(query: SearchQuery()) { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            defer {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            
            switch result {
            case .success(let graphQLResult):
                if let repositoryConnection = graphQLResult.data?.search.edges {
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
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoResultCell.cellIdentifier) as! RepoResultCell
        cell.repository = repositories[indexPath.row]
        return cell
    }
    
}
