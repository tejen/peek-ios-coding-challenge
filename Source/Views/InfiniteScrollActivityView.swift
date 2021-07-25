//
//  InfiniteScrollActivityView.swift
//  Git-a-Grep
//
//  Created by Tejen Hasmukh Patel on 7/25/21.
//  Imported from CodePath iOS Guides at https://guides.codepath.com/ios/Table-View-Guide
//
//  This class makes it easy to programmatically display an Activity Indicator below the
//    last cell within a TableView programatically, to indicate that more rows are being loaded.
//

import UIKit

class InfiniteScrollActivityView: UIView {
    
    // - MARK: Properties
    
    private var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    // - MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    // - MARK: Lifecycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    // - MARK: Private Helper Methods
    
    private func setupActivityIndicator() {
        activityIndicatorView.style = .large
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    // - MARK: Public Interface
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }
    
    func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
}
