//
//  FeedViewController.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 30/04/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

// ADDS CheckPoint of the day

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var currentFeeds = Array<FeedItem>()
    
    // MARK: Private methods
    
    
    // MARK: Life Cycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        FlickrFeedManager.sharedManager.loadPublicFeed { (feeds) in
//            print(feeds)
            if feeds != nil {
                self.currentFeeds = feeds!//feeds!.sort({ $0.dateTaken!.isGreaterThanDate($1.datePublished!) })
                self.tableView.reloadData()
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
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Public methods

}
