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
    
    fileprivate let session = SessionManager.mainSession
    fileprivate var activeDownloads = NSMutableDictionary()
    fileprivate var imageCache = ImageCache()
    let cacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    
    // MARK: Private methods
    
    /**
     Retrives the provided image from the cache directory
     - Returns: UIImage optional value
     */
    fileprivate func getImageFromDiskCache(_ imageURL: String) -> UIImage? {
        
        let filePath = cacheDir + "/\(imageURL.hash)"
        if FileManager.default.fileExists(atPath: filePath) {
            if let image = UIImage.init(data: try! Data.init(contentsOf: URL(fileURLWithPath: filePath)), scale: 1.0) {
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
    fileprivate func saveImageToCache(_ image: UIImage, fromURL: URL, toURL: URL) {
        
        imageCache.setObject(image, forKey: toURL as AnyObject)
        
        do {
            try FileManager.default.copyItem(at: fromURL, to: toURL)
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
    func downloadImage(_ imageURL: String?, completion: @escaping ((_ image: UIImage?, _ imageURL: String) -> Void)) {
        
        guard let imageURL = imageURL else {
            return
        }
        
        
        // Check if the image exists in the memory cache
        if let image = imageCache.object(forKey: imageURL as AnyObject) as? UIImage {
            completion(image, imageURL)
            return
        } else {
            // Check if the image exists in the Disk cache
            if let image = getImageFromDiskCache(imageURL) {
                imageCache.setObject(image, forKey: imageURL as AnyObject)
                completion(image, imageURL)
            } else {
                
                if activeDownloads.value(forKey: imageURL) == nil {
                    
                    guard let endpoint = URL(string: imageURL) else {
                        print("Error creating NSURL for image")
                        completion(nil, imageURL)
                        return
                    }
                    
                    //        let request = NSMutableURLRequest(URL:endpoint)
                    weak var weakSelf = self
                    
                    let downloadTask = session.downloadTask(with: endpoint, completionHandler: { (url, urlResponse, error) in
                        
                        if error == nil {
                            
                            if let image = UIImage.init(data: try! Data(contentsOf: url!)) {
                                //                        print("ImageDownloaded: \(imageURL)")
                                
                                let destinationURL = URL(fileURLWithPath: (self.cacheDir + "/\(imageURL.hash)"))
                                //                                print("Destination : \(destinationURL)")
                                
                                weakSelf?.saveImageToCache(image, fromURL: url!, toURL: destinationURL)
                                DispatchQueue.main.async(execute: {
                                    completion(image, imageURL)
                                })
                                
                            } else {
                                print("Image Not Found")
                                DispatchQueue.main.async(execute: {
                                    completion(nil, imageURL)
                                })
                            }
                            
                        } else {
                            print(error as Any)
                            DispatchQueue.main.async(execute: {
                                completion(nil, imageURL)
                            })
                        }
                        
                        weakSelf?.activeDownloads.removeObject(forKey: imageURL)
                        
                    }) 
                    // Starts the download task
                    downloadTask.resume()
                    
                    // Adding download tasks in the activeDownloads dictionary
                    activeDownloads.setObject(downloadTask, forKey: imageURL as NSCopying)
                }
            }
        }        
    }    
}
