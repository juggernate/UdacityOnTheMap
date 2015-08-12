//
//  Router.swift
//  On The Map
//
//  Created by Nathan Allison on 4/20/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import Foundation
import Alamofire

//TODO: move to PARSE SDK? this would only work with backend account access?
extension UdacityClient {
  
  enum Router: URLRequestConvertible {
    
    case UdacityLogin(String, String)
    case UdacityInfo(String)
    case FacebookLogin(String)
    case Parse
    case ParsePost(Student)
    case ParseQuery(String)
    case ParsePut(String, Student)
    
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
        
      case .FacebookLogin(let access_token):
        let params = ["facebook_mobile":["access_token": access_token]]
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
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=1000")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request
        
      case .ParseQuery(let uniqeKey):
        let params = ["where":["uniqueKey": uniqeKey]]
        let mrequest = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        mrequest.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        mrequest.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        var request = NSMutableURLRequest()
        //manually encode parameters?
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(mrequest, parameters: params)
        return request
        
      case .ParsePut(let objectId, let student):
        let params = [
          "uniqueKey": student.uniqueKey,
          "firstName": student.firstName,
          "lastName": student.lastName,
          "mediaURL": student.mediaURL,
          "longitude": student.longitude,
          "latitude": student.latitude,
          "mapString": student.mapString
        ]
        var JSONSerializationError: NSError? = nil
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation/\(objectId)"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &JSONSerializationError)
        return request
        
      case .ParsePost(let student):
        let params = [
          "uniqueKey": student.uniqueKey,
          "firstName": student.firstName,
          "lastName": student.lastName,
          "mediaURL": student.mediaURL,
          "longitude": student.longitude,
          "latitude": student.latitude,
          "mapString": student.mapString
        ]
        var JSONSerializationError: NSError? = nil
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &JSONSerializationError)
        return request
        
      }
    }
  }
}