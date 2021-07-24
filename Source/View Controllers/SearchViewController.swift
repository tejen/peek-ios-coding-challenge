//
//  SearchViewController.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/24/21.
//

import UIKit

/// **Converted from MVC to MVVM using this guide:** https://medium.com/flawless-app-stories/how-to-use-a-model-view-viewmodel-architecture-for-ios-46963c67be1b

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(RepoResultCell.nib(), forCellReuseIdentifier: RepoResultCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel = SearchViewModel()
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.tableView.alpha = 0.0
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.alpha = 1.0
                }
            }
        }
            
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch()
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoResultCell.cellIdentifier) as! RepoResultCell
        cell.viewModel = viewModel.getCellViewModel(at: indexPath)
        return cell
    }
    
}
