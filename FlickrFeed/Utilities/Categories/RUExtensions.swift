//
//  RUExtensions.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 30/04/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

import Foundation
import UIKit

// ===========================================================
// NSDate EXTENSION
// ===========================================================

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
}



// ===========================================================
// UIVIEW EXTENSION
// ===========================================================

let kAnimTime = 0.3

extension UIView {
    
    func fadeOut() {
        UIView.animateWithDuration(kAnimTime, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
    
    func fadeTo(alpha: CGFloat) {
        UIView.animateWithDuration(kAnimTime, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = alpha
            }, completion: nil)
    }
}