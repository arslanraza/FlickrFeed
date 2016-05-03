//
//  FeedDetailController.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 5/3/16.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

import UIKit
import MessageUI

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
    
    @objc private func loadCurrentFeed() {
        
        if let currentFeedItem = currentFeedItem {
            
            labelTitle.text = currentFeedItem.title
            labelAuthor.text = currentFeedItem.author
            
            let str = currentFeedItem.imageDescription!.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
            textviewDescription.text = str//currentFeedItem.imageDescription
            imageView.image = currentFeedItem.feedImage
            
        }
    }
    
    private func showImageSaveAlert() {
        RUUtility.showInfoAlert("Image Saved Successfully", message: nil, controller: self)
    }
    
    private func openFeedInBrowser() {
        if let url = NSURL(string: (currentFeedItem?.link)!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    private func shareImageWithEmail () {
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            
            mailComposeVC.addAttachmentData(UIImageJPEGRepresentation((currentFeedItem?.feedImage)!, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "feed.jpg")
            
            mailComposeVC.setSubject((currentFeedItem?.title)!)
            
            mailComposeVC.setMessageBody("<html><body><p>Saved via Flickr Feed</p></body></html>", isHTML: true)
            
            self.presentViewController(mailComposeVC, animated: true, completion: nil)
        } else {
            RUUtility.showInfoAlert("Cannot send email", message: "Please check your email settings", controller: self)
        }
    }
    
    @objc private func openSheet() {
        
        let alert = UIAlertController(title: "Actions", message: "Choose action", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Save Image", style: .Default, handler: { (action) in
            RUUtility.saveImageToGallery(self.currentFeedItem?.feedImage, target: nil, selector: nil)
            self.showImageSaveAlert()
        }))
        
        alert.addAction(UIAlertAction(title: "Open in browser", style: .Default, handler: { (action) in
            self.openFeedInBrowser()
        }))
        
        alert.addAction(UIAlertAction(title: "Share By Email", style: .Default, handler: { (action) in
            self.shareImageWithEmail()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func configureNavigationBar() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(self.openSheet))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    
    
    
    // MARK: Life Cycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentFeed()
        configureNavigationBar()
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
