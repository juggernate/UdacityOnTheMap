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
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "GET" // this is the default, don't need to specify unless NOT GET?
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request
        
      case .ParseQuery(let uniqeKey):
        let params = ["where":["uniqueKey": uniqeKey]] //??
        let mrequest = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        //                let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22\(uniqeKey)%22%3A%221234%22%7D"
        //                let url = NSURL(string: urlString)
        //                let request = NSMutableURLRequest(URL: url!)
        mrequest.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        mrequest.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        var request = NSURLRequest()
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
        
        //                request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".dataUsingEncoding(NSUTF8StringEncoding)
        
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
