//
//  RUUtility.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 30/04/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

import UIKit

class RUUtility: NSObject {

    
    static func getDateFromString(dateString: String) -> NSDate? {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
//        var newDateString = dateString.stringByReplacingOccurrencesOfString("T", withString: " ")
//        newDateString = newDateString.stringByReplacingOccurrencesOfString("Z", withString: "")
        let date = dateFormatter.dateFromString(dateString)
        
        return date
    }
    
    static func saveImageToGallery(image: UIImage?, target: AnyObject?, selector: Selector) {
        if let image = image {
            UIImageWriteToSavedPhotosAlbum(image, target, selector, nil)
        }
    }
    
    static func showInfoAlert(title: String?, message: String?, controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }
}
