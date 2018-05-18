//
//  RUUtility.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 30/04/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

import UIKit

class RUUtility: NSObject {

    /// Saves the provided image to Photo Gallery
    /// - parameters:
    ///   - image: UIImage object
    ///   - target: Target to be notified on successfull completion of image save
    ///   - selector: Selector to be called on the provided target on completion
    
    static func getDateFromString(_ dateString: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
//        var newDateString = dateString.stringByReplacingOccurrencesOfString("T", withString: " ")
//        newDateString = newDateString.stringByReplacingOccurrencesOfString("Z", withString: "")
        let date = dateFormatter.date(from: dateString)
        
        return date
    }
    
    /// Saves the provided image to Photo Gallery
    /// - parameters:
    ///   - image: UIImage object
    ///   - target: Target to be notified on successfull completion of image save
    ///   - selector: Selector to be called on the provided target on completion
    
    static func saveImageToGallery(_ image: UIImage?, target: AnyObject?, selector: Selector?) {
        if let image = image {
            UIImageWriteToSavedPhotosAlbum(image, target, selector, nil)
        }
    }
    
    /// Displays the Alert on the provided controller
    /// - parameters:
    ///   - title: String value for title
    ///   - message: String value for Message
    ///   - controller: UIViewController object on which the alert will be displayed
    /// - Returns: UIAlertController
    
    static func showInfoAlert(_ title: String?, message: String?, controller: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        controller.present(alert, animated: true, completion: nil)
        return alert
    }
}
