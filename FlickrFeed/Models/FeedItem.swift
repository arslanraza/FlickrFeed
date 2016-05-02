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
    var feedImage: UIImage?
    
    // MARK: Private methods
    
    // MARK: Life Cycle methods
    
    override init() {
        super.init()
    }
    
    // MARK: Class Level Methods
    
    static func ItemFromDictionary(dictionary: NSDictionary) -> FeedItem? {
        
        let item = FeedItem.init()
        
        item.title = dictionary["title"] as? String
        item.link = dictionary["link"] as? String
        item.imageDescription = dictionary["description"] as? String
        if let media = dictionary["media"] as? NSDictionary {
            item.imageUrlString = media["m"] as? String
        }
        
        item.author = dictionary["author"] as? String
        item.authorID = dictionary["author_id"] as? String
        
        item.dateTaken = RUUtility.getDateFromString((dictionary["date_taken"] as? String)!)
        item.datePublished = RUUtility.getDateFromString((dictionary["published"] as? String)!)
//        item.datePublished =  dictionary["published"] as? NSDate
        
        
        
        
        return item
    }
    
    
    // MARK: Public methods
    
    func displayInfo()  {
        print("Title: \(title)")
    }
}
