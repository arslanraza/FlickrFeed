//
//  FeedItem.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 30/04/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

import UIKit

class FeedItem: NSObject {
    
    
    var title: String?
    var link: String?
    var imageUrlString: String?
    var dateTaken: NSDate?
    var datePublished: NSDate?
    var imageDescription: String?
    var author: String?
    var authorID: String?
    
    // MARK: Private methods
    
    // MARK: Life Cycle methods
    
    override init() {
        super.init()
    }
    
    // MARK: Class Level Methods
    
    static func ItemFromDictionary(dictionary: NSDictionary) -> FeedItem? {
        
        let item = FeedItem.init()
        item.title = dictionary["title"] as? String
        item.imageDescription = dictionary["description"] as? String
        
        return item
    }
    
    
    // MARK: Public methods
    
}
