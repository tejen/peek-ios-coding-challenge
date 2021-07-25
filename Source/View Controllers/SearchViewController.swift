//
//  SearchViewController.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    // - MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // - MARK: Properties
    
    private var repositories = [SearchQuery.Data.Search.Edge.Node.AsRepository]()
    private var cursorPosition: String?
    private var isMoreDataLoading = false
    private var loadingMoreView: InfiniteScrollActivityView?
    
    // - MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(RepoResultCell.nib(), forCellReuseIdentifier: RepoResultCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        // prepare ui state for loading animation before initial load
        tableView.separatorStyle = .none
        
        // programmatically create an Activity Indicator and add it to bottom of the TableView...
        let frame = CGRect(x: 0,
                           y: tableView.contentSize.height,
                           width: tableView.bounds.size.width,
                           height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        // fetch the initial search results
        fetchRepositories()
    }
    
    // - MARK: Data Fetching

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
        isMoreDataLoading = true
        
        // Update position of loadingMoreView (move it to the bottom of the TableView)
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView?.frame = frame
        
        // Start the Activity Indicator at the bottom of the TableView
        loadingMoreView!.startAnimating()
        UIView.animate(withDuration: 0.4, delay: 0, options: [.beginFromCurrentState]) { [self] in
            loadingMoreView!.alpha = 1
        }
    }
    
    func didEndLoading() {
        isMoreDataLoading = false
        
        // Stop the Activity Indicator at the bottom of the TableView
        loadingMoreView!.stopAnimating()
        loadingMoreView!.alpha = 0 // prepare for the next time it appears (alpha would animate back to 1 at that time)
        
        // Show separators
        tableView.separatorStyle = .singleLine
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
    
}

extension SearchViewController: UIScrollViewDelegate {
    
    // - MARK: ScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // this powers the Infinite Scrolling functionality
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            // Check how far down the user has scrolled
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                // User has scrolled past the threshold!
                // Request more results from API...
                fetchRepositories(afterCursor: cursorPosition)
            }
        }
    }
}
