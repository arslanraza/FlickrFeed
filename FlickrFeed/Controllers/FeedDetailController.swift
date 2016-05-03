//
//  FeedDetailController.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 5/3/16.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

import UIKit

class FeedDetailController: UIViewController {
    
    // MARK: Variables
    var currentFeedItem: FeedItem?
    
    // MARK: Outlets
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelDatePublished: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textviewDescription: UITextView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewFooter: UIView!
    
    var isDetailAvailable = true
    
    // MARK: Private methods
    
    private func loadCurrentFeed() {
        
        if let currentFeedItem = currentFeedItem {
            
            labelTitle.text = currentFeedItem.title
            labelAuthor.text = currentFeedItem.author
            
            let str = currentFeedItem.imageDescription!.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
            textviewDescription.text = str//currentFeedItem.imageDescription
            imageView.image = currentFeedItem.feedImage
            
        }
    }
    
    // MARK: Life Cycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentFeed()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    @IBAction func handleTap(sender: AnyObject) {
//        print("Tap Done")
        
        if isDetailAvailable {
            self.viewHeader.fadeOut()
            self.viewFooter.fadeOut()
            isDetailAvailable = false
        } else {
            self.viewHeader.fadeTo(0.5)
            self.viewFooter.fadeTo(0.5)
            isDetailAvailable = true
        }
        
    }
}
