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
        
        case UdacityLogin(String, String)
        case UdacityInfo(String)
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
                
            case .UdacityInfo(let userID):
                return NSURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userID)")!)
            
            case .Parse:
                let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
                request.HTTPMethod = "GET" // this is the default, don't need to specify unless NOT GET?
                request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
                request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
                return request
            }
        }
    }
}
