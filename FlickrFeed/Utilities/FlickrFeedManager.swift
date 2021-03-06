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
enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class FlickrFeedManager: NSObject {
    
    static let sharedManager = FlickrFeedManager()
    
    // Mark: Private Vars
    fileprivate let session = SessionManager.mainSession
    
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
    
    func loadFeedForURL(_ urlString: String, completion: @escaping ((_ feeds: Array<FeedItem>?) -> Void)) {
        let urlPath = urlString
        
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating Public API URL")
            completion(nil)
            return
        }
        
        let request = URLRequest(url: endpoint) //NSMutableURLRequest(url:endpoint)
        
        
        
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                
                /**
                 JSON from flicker contains escape sequence \' which is not a valid json string.
                 We will have to extra step to remove the occurances of above escapse sequence
                 */
                var jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                //                print(jsonString)
                
                // Removing the occurances of escape sequence which casues JSON parsing issues.
                jsonString = jsonString?.replacingOccurrences(of: "\\'", with: "'") as! NSString
                
                // Creating new data object from the refined json string
                let refinedData = jsonString?.data(using: String.Encoding.utf8.rawValue)
                
                // PARSING JSON DATA
                guard let json = try JSONSerialization.jsonObject(with: refinedData!, options: []) as? NSDictionary else {
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
                
                DispatchQueue.main.async(execute: {
                    completion(feeds)
                })
                
            } catch let error as JSONError {
                print(error.rawValue)
                DispatchQueue.main.async(execute: {
                    completion(nil)
                })
            } catch let error as NSError {
                print(error.debugDescription)
                DispatchQueue.main.async(execute: {
                    completion(nil)
                })
            }
            }) .resume()
    }
    
    /**
     Load Public Feed from Flickr Public API
     - Returns: An optional object of public feed array
     */
    func loadPublicFeed(_ completion: @escaping ((_ feeds: Array<FeedItem>?) -> Void)) {
        loadFeedForURL(kPublicFeedURL, completion: completion)
    }
    
    /**
     Search Public Feed with provided tags seperated by commas
     - Returns: An optional object of public feed array
     */
    func searchFeedWithTag(_ tag: String, completion: @escaping ((_ feeds: Array<FeedItem>?) -> Void)) {
        let urlString = kPublicFeedURL + "&tags=\(tag)"
        loadFeedForURL(urlString, completion: completion)
    }
    
    
    
}
