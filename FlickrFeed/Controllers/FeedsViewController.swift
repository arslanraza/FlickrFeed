//
//  FeedViewController.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 30/04/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

// Adds Work Start CheckPoint

import UIKit

class FeedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var currentFeeds = Array<FeedItem>()
    private var selectedIndexPath: NSIndexPath?
    
    // MARK: Private methods
    
    private func sortFeed(byDateTaken: Bool) {
        if byDateTaken {
            currentFeeds = currentFeeds.sort({ $0.dateTaken!.isGreaterThanDate($1.dateTaken!) })
        } else {
            currentFeeds = currentFeeds.sort({ $0.datePublished!.isGreaterThanDate($1.datePublished!) })
        }
        
        self.tableView.reloadData()
        self.downloadImagesForVisibleCells()
    }
    
    
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
                                if let visibleCell = self.tableView.cellForRowAtIndexPath(indexPath) as? FeedItemCell {
                                    visibleCell.feedImageView.image = image
                                }
                            }
                    })
                }
            }
        }
    }
    
    // MARK: Life Cycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        weak var weakSelf = self
        FlickrFeedManager.sharedManager.loadPublicFeed { (feeds) in
            //            print(feeds)
            if feeds != nil {
                weakSelf?.currentFeeds = feeds!//feeds!.sort({ $0.dateTaken!.isGreaterThanDate($1.datePublished!) })
                weakSelf?.sortFeed(true)
            }
        }
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
        cell.feedTitle.text = singleFeed.title
        if singleFeed.feedImage == nil {
            cell.feedImageView.image = UIImage.init(named: "placeHolder")
        } else {
            cell.feedImageView.image = singleFeed.feedImage
        }
        //        ImageDownloader.sharedInstance.downloadImage(singleFeed.imageUrlString) { (image, imageURL) in
        //            cell.feedImageView.image = image
        //        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
    
    
    // MARK: Public methods
    
    @IBAction func segmentChanged(segmentControl: UISegmentedControl) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            sortFeed(true)
        } else {
            sortFeed(false)
        }
    }
    
}