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
    
    // MARK: Private methods
    private let session = SessionManager.mainSession
    
    // MARK: Life Cycle methods
    
    override init() {
        super.init()
        
    }
    
    // MARK: Public methods
    
    /**
     Download image for the given url string
     @param imageURL: URL string for the image to be downloaded
     @param completion: A completion block which will return an optional image object
     */
    func downloadImage(imageURL: String?, completion: ((image: UIImage?) -> Void)) {
        
        guard let endpoint = NSURL(string: imageURL!) else {
            print("Error creating NSURL for image")
            return
        }
        
        //        let request = NSMutableURLRequest(URL:endpoint)
        
        session.downloadTaskWithURL(endpoint) { (url, urlResponse, error) in
            if error == nil {
                if let image = UIImage.init(data: NSData(contentsOfURL: url!)!) {
//                    print("ImageDownloaded: \(imageURL)")
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(image: image)
                    })
                    
                } else {
                    print("Image Not Found")
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(image: nil)
                    })
                }
                
            } else {
                print(error)
                dispatch_async(dispatch_get_main_queue(), {
                    completion(image: nil)
                })
            }
            }.resume()
        
        
    }
}