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
    private let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    
    // MARK: Private methods
    
    // MARK: Life Cycle methods
    
    override init() {
        super.init()
    }
    
    // MARK: Public methods
    
 /**
     Load Public Feed from Flickr Public API
     - @return feeds: Returns a list of public feed. Returns nil if no feed is found
 */
    func loadPublicFeed(completion: ((feeds: Array<FeedItem>?) -> Void)) {
        
        let urlPath = kPublicFeedURL
        
        guard let endpoint = NSURL(string: urlPath) else {
            print("Error creating Public API URL")
            return
        }
        
        let request = NSMutableURLRequest(URL:endpoint)
        
        session.dataTaskWithRequest(request) { (data, response, error) in
            
            if (error == nil) {
                
            }
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                    //                    return
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments]) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                    //                    return
                }
                print(json)
                
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
    
}
