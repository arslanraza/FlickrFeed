//
//  FlickrFeedManager.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 30/04/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

import UIKit

let kPublicFeedURL       = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"

// Defining enum to manage JSON Parsing & fetching errors
enum JSONError: String, ErrorType {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class FlickrFeedManager: NSObject {
    
    static let sharedManager = FlickrFeedManager()
    
    // Mark: Private Vars
    private let session = SessionManager.mainSession
    
    // MARK: Private methods
    
    // MARK: Life Cycle methods
    
    override init() {
        super.init()
    }
    
    // MARK: Public methods
    
    /**
     Load Feed from Flickr Public API
     - Parameters: urlString a String value of the url to be loaded
     - Returns: An optional object of public feed array
     */
    
    func loadFeedForURL(urlString: String, completion: ((feeds: Array<FeedItem>?) -> Void)) {
        let urlPath = urlString
        
        guard let endpoint = NSURL(string: urlPath) else {
            print("Error creating Public API URL")
            completion(feeds: nil)
            return
        }
        
        let request = NSMutableURLRequest(URL:endpoint)
        session.dataTaskWithRequest(request) { (data, response, error) in
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                
                /**
                 JSON from flicker contains escape sequence \' which is not a valid json string.
                 We will have to extra step to remove the occurances of above escapse sequence
                 */
                var jsonString = NSString(data: data, encoding: NSUTF8StringEncoding)
                //                print(jsonString)
                
                // Removing the occurances of escape sequence which casues JSON parsing issues.
                jsonString = jsonString?.stringByReplacingOccurrencesOfString("\\'", withString: "'")
                
                // Creating new data object from the refined json string
                let refinedData = jsonString?.dataUsingEncoding(NSUTF8StringEncoding)
                
                // PARSING JSON DATA
                guard let json = try NSJSONSerialization.JSONObjectWithData(refinedData!, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                
                //                print(json)
                
                guard let items = json["items"] as? Array<NSDictionary> else {
                    throw JSONError.ConversionFailed
                }
                
                var feeds = Array<FeedItem>()
                
                for singleItemData in items {
                    let singleFeed = FeedItem.ItemFromDictionary(singleItemData)
                    feeds.append(singleFeed!)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completion(feeds: feeds)
                })
                
            } catch let error as JSONError {
                print(error.rawValue)
                dispatch_async(dispatch_get_main_queue(), {
                    completion(feeds: nil)
                })
            } catch let error as NSError {
                print(error.debugDescription)
                dispatch_async(dispatch_get_main_queue(), {
                    completion(feeds: nil)
                })
            }
            }.resume()
    }
    
    /**
     Load Public Feed from Flickr Public API
     - Returns: An optional object of public feed array
     */
    func loadPublicFeed(completion: ((feeds: Array<FeedItem>?) -> Void)) {
        loadFeedForURL(kPublicFeedURL, completion: completion)
    }
    
    func searchFeedWithTag(tag: String, completion: ((feeds: Array<FeedItem>?) -> Void)) {
        let urlString = kPublicFeedURL.stringByAppendingString("&tags=\(tag)")
        loadFeedForURL(urlString, completion: completion)
    }
    
    
    
}