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

extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
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
        UIView.animate(withDuration: kAnimTime, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
    
    func fadeTo(_ alpha: CGFloat) {
        UIView.animate(withDuration: kAnimTime, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = alpha
            }, completion: nil)
    }
}
