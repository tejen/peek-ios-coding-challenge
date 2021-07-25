//
//  SearchViewController.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import UIKit

/// **Converted from MVC to MVVM using this tutorial:** https://medium.com/flawless-app-stories/how-to-use-a-model-view-viewmodel-architecture-for-ios-46963c67be1b

class SearchViewController: UIViewController, SearchControllerDelegate {
    
    // - MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // - MARK: Properties
    
    private var viewModel: SearchControllerViewModel!
    private var loadingIndicatorView: InfiniteScrollActivityView?
    
    // - MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // intialize ViewModel
        viewModel = SearchControllerViewModel(delegate: self)
        
        // initialize TableView
        tableView.register(RepoResultCell.nib(), forCellReuseIdentifier: RepoResultCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        
        // initialize SearchBar
        searchBar.delegate = self
        // set initial search query
        searchBar.text = "graphql"
        
        // prepare ui state for loading animation before initial load
        tableView.separatorStyle = .none
        
        // programmatically create an Activity Indicator and add it to bottom of the TableView...
        let frame = CGRect(x: 0,
                           y: tableView.contentSize.height,
                           width: tableView.bounds.size.width,
                           height: InfiniteScrollActivityView.defaultHeight)
        loadingIndicatorView = InfiniteScrollActivityView(frame: frame)
        loadingIndicatorView!.isHidden = true
        tableView.addSubview(loadingIndicatorView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        // fetch the initial search results
        viewModel.fetchRepositories()
    }
    
    // - MARK: Delegate Methods for ViewModel
    
    func didStartLoading() {
        
        // Update position of loadingMoreView (move it to the bottom of the TableView)
        let isTableViewEmpty = tableView.indexPathsForVisibleRows?.count ?? 0 < 1
        let frameY = isTableViewEmpty ? tableView.frame.height / 2 - searchBar.frame.height : tableView.contentSize.height
        let frame = CGRect(x: 0, y: frameY,
                           width: tableView.bounds.size.width,
                           height: InfiniteScrollActivityView.defaultHeight)
        loadingIndicatorView?.frame = frame
        
        // Start the Activity Indicator at the bottom of the TableView
        loadingIndicatorView!.startAnimating()
        UIView.animate(withDuration: 0.4, delay: 0, options: [.beginFromCurrentState]) { [self] in
            loadingIndicatorView!.alpha = 1
        }
    }
    
    func didEndLoading() {
        // Refresh cells displayed in TableView
        tableView.separatorStyle = .singleLine
        tableView.reloadData()
        
        // Stop the Activity Indicator at the bottom of the TableView
        loadingIndicatorView!.stopAnimating()
        loadingIndicatorView!.alpha = 0 // prepare for the next time it appears (alpha would animate back to 1 at that time)
        
        // Show separators
        tableView.separatorStyle = .singleLine
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // - MARK: TableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.cellForRowAtIndexPath(indexPath, tableView: tableView)
    }
    
}

extension SearchViewController: UIScrollViewDelegate {
    
    // - MARK: ScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // this powers the Infinite Scrolling functionality
        if (!viewModel.isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            // Check how far down the user has scrolled
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                // User has scrolled past the threshold!
                // Request more results from API...
                viewModel.fetchMoreRepositories()
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    // - MARK: SearchBar Delegate Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        viewModel.willClearTableView()
        
        searchBar.resignFirstResponder()
        
        // Clear the entire TableView (animated)
        tableView.beginUpdates()
        tableView.deleteSections([0], with: .fade) // destroy all existing rows
        tableView.insertSections([0], with: .fade)
        tableView.endUpdates() // this triggers the above animations to remove all rows
        tableView.separatorStyle = .none // will be reverted momentarily by didEndLoading...
        tableView.reloadData() // this applies the above change to separatorStyle
        
        viewModel.fetchRepositories()
    }
}
