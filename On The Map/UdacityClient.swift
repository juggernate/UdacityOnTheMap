//
//  UdacityClient.swift
//  On The Map
//
//  Created by Nathan Allison on 4/8/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UdacityClient: NSObject {
    
    enum Router: URLRequestConvertible {
//        static let baseUdacityURLString = "https://www.udacity.com/api/session"
//        static let baseParseURLString = "https://api.parse.com/1/classes/StudentLocation"
        
        case UdacityLogin(String, String)
        case Parse
        
        var URLRequest: NSURLRequest {
            switch self {
                
            case .UdacityLogin(let username, let password):
                let params = ["udacity":["username": username, "password": password]]
                var JSONSerializationError: NSError? = nil
                
                let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
                request.HTTPMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &JSONSerializationError)
                return request
            
            case .Parse:
                let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
                request.HTTPMethod = "GET" // this is the default
                request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
                request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
                return request
            }
//            let (path: String, parameters: [String: AnyObject]) = {
//                switch self {
//                case .UdacityLogin(let username, let password):
//                    //hey diddle diddle
//                    
//                    
//                case .PopularPhotos (let page):
//                    let params = ["consumer_key": Router.consumerKey, "page": "\(page)", "feature": "popular", "rpp": "50",  "include_store": "store_download", "include_states": "votes"]
//                    return ("/photos", params)
//                case .PhotoInfo(let photoID, let imageSize):
//                    var params = ["consumer_key": Router.consumerKey, "image_size": "\(imageSize.rawValue)"]
//                    return ("/photos/\(photoID)", params)
//                case .Comments(let photoID, let commentsPage):
//                    var params = ["consumer_key": Router.consumerKey, "comments": "1", "comments_page": "\(commentsPage)"]
//                    return ("/photos/\(photoID)/comments", params)
//                }
//            }()
//            
//            let URL = NSURL(string: Router.baseURLString)
//            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
//            let encoding = Alamofire.ParameterEncoding.URL
//            
//            return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
}
