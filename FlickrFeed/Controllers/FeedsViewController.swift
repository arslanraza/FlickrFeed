//
//  FeedViewController.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 30/04/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

// Checkpoint for Stopping Work

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class FeedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var currentFeeds = Array<FeedItem>()
    fileprivate var selectedIndexPath: IndexPath?
    
    // MARK: Private methods
    
    /**
     Sort feeds by Date Taken
     - Parameters:
         - byDateTaken: Boolean value. Will sort by published date when passed false
     */
    fileprivate func sortFeed(_ byDateTaken: Bool) {
        hideKeyboard()
        if byDateTaken {
            currentFeeds = currentFeeds.sorted(by: { $0.dateTaken!.isGreaterThanDate($1.dateTaken!) })
        } else {
            currentFeeds = currentFeeds.sorted(by: { $0.datePublished!.isGreaterThanDate($1.datePublished!) })
        }
        
        self.tableView.reloadData()
        self.downloadImagesForVisibleCells()
    }
    
    /**
     Downloads Images for only visible cells.
     */
    fileprivate func downloadImagesForVisibleCells() {
        if currentFeeds.count > 0 {
            
            let visiblePaths = tableView.indexPathsForVisibleRows
            for indexPath in visiblePaths! {
                let singleFeed = currentFeeds[indexPath.row]
                if singleFeed.feedImage == nil {
                    //                    print("Downloading Image for: \(indexPath.row)")
                    ImageDownloader.sharedInstance.downloadImage(singleFeed.imageUrlString
                        , completion: { (image, imageURL) in
                            if let image = image {
                                singleFeed.feedImage = image
                                // VisibleCell will only have a value if its currently displayed on screen
                                // Out of bound cells will return for the following check
                                if let visibleCell = self.tableView.cellForRow(at: indexPath) as? FeedItemCell {
                                    visibleCell.imageViewFeed.image = image
                                }
                            }
                    })
                }
            }
        }
    }
    
    /**
     Hides the keyboard if its present on screen
    */
    fileprivate func hideKeyboard() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    /**
     Loads Public Flickr Feed
     */
    @objc fileprivate func loadPublicFeed() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        weak var weakSelf = self
        FlickrFeedManager.sharedManager.loadPublicFeed { (feeds) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if feeds != nil {
                weakSelf?.currentFeeds = feeds!
                weakSelf?.sortFeed(true)
            }
        }
    }
    
    /**
     Configures navigation bar
     */
    fileprivate func configureNavigationBar() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.loadPublicFeed))
        navigationItem.rightBarButtonItem = barButton
    }
    
    // MARK: Life Cycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        loadPublicFeed()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentFeeds.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedItemCell
        
        let singleFeed = currentFeeds[indexPath.row]
        cell.labelTitle.text = singleFeed.title
        cell.labelAuthor.text = singleFeed.author
        cell.labelDatePublished.text = singleFeed.getDatePublishedString()
        
        if singleFeed.feedImage == nil {
            cell.imageViewFeed.image = UIImage.init(named: "placeHolder")
        } else {
            cell.imageViewFeed.image = singleFeed.feedImage
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hideKeyboard()
        selectedIndexPath = indexPath
        performSegue(withIdentifier: Segues.FeedDetailView, sender: self)
    }
    
    // MARK: UIScrollVIewDelegate Methods
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("didEndDecelerating")
        downloadImagesForVisibleCells()
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == Segues.FeedDetailView {
            print("Perform Custom Action")
            let singleFeed = currentFeeds[selectedIndexPath!.row]
            let feedDetailView = segue.destination as! FeedDetailController
            feedDetailView.title = "Feed Detail"
            feedDetailView.currentFeedItem = singleFeed
        }
     }
    
    // MARK: UISearchBarDelegate Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
        if searchBar.text?.characters.count > 0 {
            weak var weakSelf = self
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            FlickrFeedManager.sharedManager.searchFeedWithTag(searchBar.text!, completion: { (feeds) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if feeds != nil {
                    weakSelf?.currentFeeds = feeds!
                    weakSelf?.sortFeed(true)
                }
            })
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
    
    
    // MARK: Public methods
    
    @IBAction func segmentChanged(_ segmentControl: UISegmentedControl) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            sortFeed(true)
        } else {
            sortFeed(false)
        }
    }
    
    
    
}
