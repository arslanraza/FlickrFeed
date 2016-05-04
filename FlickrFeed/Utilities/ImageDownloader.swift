//
//  RUImageDownloader.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 01/05/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

import Foundation
import UIKit

/**
 Class to handle all image downloads and cache managemments
 */
class ImageDownloader: NSObject {
    static let sharedInstance = ImageDownloader()
    
    private let session = SessionManager.mainSession
    private var activeDownloads = NSMutableDictionary()
    private var imageCache = ImageCache()
    let cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
    
    // MARK: Private methods
    
    /**
     Retrives the provided image from the cache directory
     - Returns: UIImage optional value
     */
    private func getImageFromDiskCache(imageURL: String) -> UIImage? {
        
        let filePath = cacheDir.stringByAppendingString("/\(imageURL.hash)")
        if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
            if let image = UIImage.init(data: NSData.init(contentsOfURL: NSURL(fileURLWithPath: filePath))!, scale: 1.0) {
                return image
            }
        }
        return nil
    }
    
    /**
     Saves the provided image to the cache directory
    - Parameters:
       - image: UIImage to be saved in cache
       - toURL: UIImage initial location on disk created by DownloadTask
       - toURL: NSURL location where the image will be stored
     */
    private func saveImageToCache(image: UIImage, fromURL: NSURL, toURL: NSURL) {
        
        imageCache.setObject(image, forKey: toURL)
        
        do {
            try NSFileManager.defaultManager().copyItemAtURL(fromURL, toURL: toURL)
        } catch  {
            print("Error saving image cache: \(error)")
        }
    }
    
    // MARK: Life Cycle methods
    
    override init() {
        super.init()
        
    }
    
    // MARK: Public methods
    
    
    /// Download image for the given url string
    /// - parameters:
    ///   - imageURL: String value for the url
    ///   - completion: A completion clousure
    func downloadImage(imageURL: String?, completion: ((image: UIImage?, imageURL: String) -> Void)) {
        
        guard let imageURL = imageURL else {
            return
        }
        
        
        // Check if the image exists in the memory cache
        if let image = imageCache.objectForKey(imageURL) as? UIImage {
            completion(image: image, imageURL: imageURL)
            return
        } else {
            // Check if the image exists in the Disk cache
            if let image = getImageFromDiskCache(imageURL) {
                imageCache.setObject(image, forKey: imageURL)
                completion(image: image, imageURL: imageURL)
            } else {
                
                if activeDownloads.valueForKey(imageURL) == nil {
                    
                    guard let endpoint = NSURL(string: imageURL) else {
                        print("Error creating NSURL for image")
                        return
                    }
                    
                    //        let request = NSMutableURLRequest(URL:endpoint)
                    weak var weakSelf = self
                    
                    let downloadTask = session.downloadTaskWithURL(endpoint) { (url, urlResponse, error) in
                        
                        if error == nil {
                            
                            if let image = UIImage.init(data: NSData(contentsOfURL: url!)!) {
                                //                        print("ImageDownloaded: \(imageURL)")
                                
                                let destinationURL = NSURL(fileURLWithPath: (self.cacheDir.stringByAppendingString("/\(imageURL.hash)")))
                                //                                print("Destination : \(destinationURL)")
                                
                                weakSelf?.saveImageToCache(image, fromURL: url!, toURL: destinationURL)
                                dispatch_async(dispatch_get_main_queue(), {
                                    completion(image: image, imageURL: imageURL)
                                })
                                
                            } else {
                                print("Image Not Found")
                                dispatch_async(dispatch_get_main_queue(), {
                                    completion(image: nil, imageURL: imageURL)
                                })
                            }
                            
                        } else {
                            print(error)
                            dispatch_async(dispatch_get_main_queue(), {
                                completion(image: nil, imageURL: imageURL)
                            })
                        }
                        
                        weakSelf?.activeDownloads.removeObjectForKey(imageURL)
                        
                    }
                    downloadTask.resume()
                    activeDownloads.setObject(downloadTask, forKey: imageURL)
                }
                
            }
        }        
    }
}