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
    @IBOutlet weak var viewContainer: UIView!
    
    var isDetailAvailable = true
    
    // MARK: Private methods
    
    /**
     Loads current Feed data to the UI
     */
    @objc fileprivate func loadCurrentFeed() {
        
        if let currentFeedItem = currentFeedItem {
            
            labelTitle.text = currentFeedItem.title
            labelAuthor.text = currentFeedItem.author
            
            let str = currentFeedItem.imageDescription!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            textviewDescription.text = str//currentFeedItem.imageDescription
            imageView.image = currentFeedItem.feedImage
            
        }
    }
    
    /**
     Displays Alert when image is successfully saved
     */
    fileprivate func showImageSaveAlert() {
        RUUtility.showInfoAlert("Image Saved Successfully", message: nil, controller: self)
    }
    
    /**
     Opens the feed in the Safari Browser
     */
    fileprivate func openFeedInBrowser() {
        if let url = URL(string: (currentFeedItem?.link)!) {
            UIApplication.shared.openURL(url)
        }
    }
    
    /**
     Opens default mail client with image as an attachment
     - Returns: MFMailComposeViewController
     */
    fileprivate func shareImageWithEmail () -> MFMailComposeViewController? {
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            
            mailComposeVC.addAttachmentData(UIImageJPEGRepresentation((currentFeedItem?.feedImage)!, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "feed.jpg")
            
            mailComposeVC.setSubject((currentFeedItem?.title)!)
            
            mailComposeVC.setMessageBody("<html><body><p>Shared via Flickr Feed</p></body></html>", isHTML: true)
            
            self.present(mailComposeVC, animated: true, completion: nil)
            
            return mailComposeVC
        } else {
            RUUtility.showInfoAlert("Cannot send email", message: "Please check your email settings", controller: self)
        }
        
        return nil
    }
    
    @objc fileprivate func openSheet() {
        
        let alert = UIAlertController(title: "Actions", message: "Choose action", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Save Image", style: .default, handler: { (action) in
            RUUtility.saveImageToGallery(self.currentFeedItem?.feedImage, target: nil, selector: nil)
            self.showImageSaveAlert()
        }))
        
        alert.addAction(UIAlertAction(title: "Open in browser", style: .default, handler: { (action) in
            self.openFeedInBrowser()
        }))
        
        alert.addAction(UIAlertAction(title: "Share By Email", style: .default, handler: { (action) in
            self.shareImageWithEmail()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func configureNavigationBar() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.openSheet))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    fileprivate func runScaleAnimation() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.viewContainer.alpha = 1.0
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.viewContainer.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }) 
        }) 
    }
    
    // MARK: Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentFeed()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewContainer.alpha = 0
        self.viewContainer.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runScaleAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Public methods
    
    /**
    Hides or Unhides the Header and Footer view on tap event
    */
    @IBAction func handleTap(_ sender: AnyObject) {
        //        print("Tap Done")
        
        if isDetailAvailable {
            self.viewHeader.fadeOut()
            self.viewFooter.fadeOut()
            isDetailAvailable = false
        } else {
            self.viewHeader.fadeTo(0.7)
            self.viewFooter.fadeTo(0.7)
            isDetailAvailable = true
        }
        
    }
}
