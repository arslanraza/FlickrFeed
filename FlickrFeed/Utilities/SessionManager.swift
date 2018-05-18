//
//  SessionManager.swift
//  FlickrFeed
//
//  Created by Arslan Raza on 02/05/2016.
//  Copyright © 2016 Arslan Raza. All rights reserved.
//

import Foundation

class SessionManager  {
    
    /**
     MAIN NSURLSession which will be used for all network calls
     */
    static let mainSession =  URLSession.init(configuration: URLSessionConfiguration.default)
    
}
