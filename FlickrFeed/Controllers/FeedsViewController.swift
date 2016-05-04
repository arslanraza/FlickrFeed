//
//  FeedViewController.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 30/04/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

// Checkpoint for Stopping Work

import UIKit

class FeedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var currentFeeds = Array<FeedItem>()
    private var selectedIndexPath: NSIndexPath?
    
    // MARK: Private methods
    
    /**
     Sort feeds by Date Taken
     - Parameters:
         - byDateTaken: Boolean value. Will sort by published date when passed false
     */
    private func sortFeed(byDateTaken: Bool) {
        hideKeyboard()
        if byDateTaken {
            currentFeeds = currentFeeds.sort({ $0.dateTaken!.isGreaterThanDate($1.dateTaken!) })
        } else {
            currentFeeds = currentFeeds.sort({ $0.datePublished!.isGreaterThanDate($1.datePublished!) })
        }
        
        self.tableView.reloadData()
        self.downloadImagesForVisibleCells()
    }
    
    /**
     Downloads Images for only visible cells.
     */
    private func downloadImagesForVisibleCells() {
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
                                if let visibleCell = self.tableView.cellForRowAtIndexPath(indexPath) as? FeedItemCell {
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
    private func hideKeyboard() {
        if searchBar.isFirstResponder() {
            searchBar.resignFirstResponder()
        }
    }
    
    /**
     Loads Public Flickr Feed
     */
    @objc private func loadPublicFeed() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        weak var weakSelf = self
        FlickrFeedManager.sharedManager.loadPublicFeed { (feeds) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if feeds != nil {
                weakSelf?.currentFeeds = feeds!
                weakSelf?.sortFeed(true)
            }
        }
    }
    
    /**
     Configures navigation bar
     */
    private func configureNavigationBar() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(self.loadPublicFeed))
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentFeeds.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as! FeedItemCell
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hideKeyboard()
        selectedIndexPath = indexPath
        performSegueWithIdentifier(Segues.FeedDetailView, sender: self)
    }
    
    // MARK: UIScrollVIewDelegate Methods
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("didEndDecelerating")
        downloadImagesForVisibleCells()
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == Segues.FeedDetailView {
            print("Perform Custom Action")
            let singleFeed = currentFeeds[selectedIndexPath!.row]
            let feedDetailView = segue.destinationViewController as! FeedDetailController
            feedDetailView.title = "Feed Detail"
            feedDetailView.currentFeedItem = singleFeed
        }
     }
    
    // MARK: UISearchBarDelegate Methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        hideKeyboard()
        if searchBar.text?.characters.count > 0 {
            weak var weakSelf = self
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            FlickrFeedManager.sharedManager.searchFeedWithTag(searchBar.text!, completion: { (feeds) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if feeds != nil {
                    weakSelf?.currentFeeds = feeds!
                    weakSelf?.sortFeed(true)
                }
            })
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideKeyboard()
    }
    
    
    // MARK: Public methods
    
    @IBAction func segmentChanged(segmentControl: UISegmentedControl) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            sortFeed(true)
        } else {
            sortFeed(false)
        }
    }
    
    
    
}