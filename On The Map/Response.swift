//
// Created by Nathan Allison on 4/22/15.
// Copyright (c) 2015 shondicon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension UdacityClient {

  func checkURL(request: NSURLRequest, completionHandler: (errorString: String?) -> Void) {
    
    //prep request first or pass string or url?
    //pass acceptable range?
    Alamofire.request(request)
    .validate()
    .response{(_, response, _, error) in
      
      var errorString: String? = nil
      
      if let networkError = error {
        
        errorString = "Network Error: \(networkError.localizedDescription)"
        
        //error AND status code -- TODO: better status code parsing
        if let response = response{
          errorString = "\(response.statusCode) Not Found: \(request.URL!)"
        }
      }
      completionHandler(errorString: errorString)
    }
  }
  
  //MARK: - Udacity API Response Handlers
  func getSession(user: String, password: String, completionHandler: (uniqeKey: String?, errorString: String?) -> Void ) {

    Alamofire.request(Router.UdacityLogin(user, password)).response() {
      (_, _, DATA, ERROR) in

      if let networkError = ERROR {
        let errorString = "Network Error: \(networkError.localizedDescription)"
        completionHandler(uniqeKey: nil, errorString: errorString)
        return
      }

      if let data = DATA {
        let json = JSON(data: self.stripUdacityData(data))

        if var responseError = json["error"].string {
          //Not the best place to strip this?
          if let range = responseError.rangeOfString("trails.Error 400: "){
            responseError.removeRange(range)
          }
          completionHandler(uniqeKey: nil, errorString: "Login Error: \(responseError)")
          return
        }

        if let key = json["account"]["key"].string {
//          User.sharedInstance.info.uniqueKey = key
          completionHandler(uniqeKey: key, errorString: nil)
          return
        }
      }
      completionHandler(uniqeKey: nil, errorString: "Data Error: Unique Key Unavailable")
    }
  }

  func getUserData(uniqeKey: String, completionHandler: (json: JSON?, errorString: String?) -> Void ) {

    Alamofire.request(Router.UdacityInfo(uniqeKey)).response() {
      (_, _, DATA, ERROR) in

      if let networkError = ERROR {
        let errorString = "Network Error: \(networkError.localizedDescription)"
        completionHandler(json: nil, errorString: errorString)
        return
      }

      if let data = DATA {
        let json = JSON(data: self.stripUdacityData(data))

        if let responseError = json["error"].string {
          //TODO: strip "trails.Error 4xx"?
          completionHandler(json: nil, errorString: "Login Error: \(responseError)")
          return
        }

        completionHandler(json: json, errorString: nil)
        return
      }
      completionHandler(json: nil, errorString: "Data Error: User Info Unavailable")
    }
  }

  //MARK: - Parse API Response Handlers
  func updateStudentsList(completionHandler:(json:[JSON]?, errorString: String?)->Void) {
    
    Alamofire.request(UdacityClient.Router.Parse).responseJSON() {
      (_, _, DATA, ERROR) in
      
      if let networkError = ERROR {
        let errorString = "Network Error: \(networkError.localizedDescription)"
        completionHandler(json: nil, errorString: errorString)
        return
      }
      
      let json = JSON(DATA!)
      if let responseError = json["error"].string {
        let errorString = "Response Error: \(responseError)"
        completionHandler(json: nil, errorString: errorString)
        return
      }
      
      if let results = json["results"].array{
        if results.count > 0 {
          completionHandler(json: results, errorString: nil)
          return
        }
        completionHandler(json: nil, errorString: "Data Error: No Students Found")
        return
      }
      
      completionHandler(json: nil, errorString: "Data Error: Students Info Unavailable")
    }
  }

  
  
  func parseQuery(uniqueKey: String, completionHandler: (objectId: String?, errorString: String?) -> Void ) {

    Alamofire.request(Router.ParseQuery(uniqueKey)).responseJSON { (_, _, DATA, ERROR) in

      if let networkError = ERROR {
        let errorString = "Network Error: \(networkError.localizedDescription)"
        completionHandler(objectId: nil, errorString: errorString)
        return
      }

      let json = JSON(DATA!)
      if let responseError = json["error"].string {
        let errorString = "Response Error: \(responseError)"
        completionHandler(objectId: nil, errorString: errorString)
        return
      }

      let results = JSON(DATA!)["results"]
      if results.count > 0 {
        if let objectId = results[0]["objectId"].string {
          completionHandler(objectId: objectId, errorString: nil)
          return
        }
      }
      completionHandler(objectId: nil, errorString: nil)
    }
  }

  //update existing
  func parsePut(objectId: String, student: Student, completionHandler: (errorString: String?) -> Void ) {

    Alamofire.request(Router.ParsePut(objectId, student))
    .responseJSON { (_, _, DATA, ERROR) in

      if let networkError = ERROR {
        let errorString = "Network Error: \(networkError.localizedDescription)"
        completionHandler(errorString: errorString)
        return
      }

      let json = JSON(DATA!)

      if let responseError = json["error"].string {
        let errorString = "Response Error: \(responseError)"
        completionHandler(errorString: errorString)
        return
      }

      completionHandler(errorString: nil)
    }
  }

  func parsePost(student: Student, completionHandler: (errorString: String?) -> Void ) {

    Alamofire.request(Router.ParsePost(student)).responseJSON { (_, _, DATA, ERROR) in

      if let networkError = ERROR {
        let errorString = "Network Error: \(networkError.localizedDescription)"
        completionHandler(errorString: errorString)
        return
      }

      let json = JSON(DATA!)

      if let responseError = json["error"].string {
        let errorString = "Response Error: \(responseError)"
        completionHandler(errorString: errorString)
        return
      }

      completionHandler(errorString: nil)
    }
  }
}