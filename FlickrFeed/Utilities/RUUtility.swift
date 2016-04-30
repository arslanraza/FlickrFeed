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
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        
        var newDateString = dateString.stringByReplacingOccurrencesOfString("T", withString: " ")
        newDateString = newDateString.stringByReplacingOccurrencesOfString("Z", withString: "")
        let date = dateFormatter.dateFromString(newDateString)
        
        return date
    }
    
}
