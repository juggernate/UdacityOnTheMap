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

  static let sharedInstance = UdacityClient()

  //TODO: move the requests from login view controller here, take a completion handler to call back to login
  var token: String?
  var tokenDate: NSDate?
  let tokenThresholdInDays = 30
  
  //if valid token within date just return success
  //TODO: invalidate token after certain conditions (date, system reset?)
  //TODO: logout should invalidate token
  
  //MARK: - External Callers
  
  func login(user: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void ) {
    //getSession
    getSession(user, password: password) { (uniqueKey, errorString) in
      
      if let error = errorString {
        completionHandler(success: false, errorString: error)
        return
      }
      
      if let key = uniqueKey {
        self.getUserData(key) { (success, errorString) in

          if let error = errorString {
            completionHandler(success: false, errorString: error)
            return
          }

          if success {
            completionHandler(success: true, errorString: nil)
            return
          }
        }
      }
      //get here unspecified error?
    }
    
  }
  //MARK: - Request Handlers
  func getSession(user: String, password: String, completionHandler: (uniqeKey: String?, errorString: String?) -> Void ) {
    
    Alamofire.request(Router.UdacityLogin(user, password)).response() {
      (_, _, DATA, ERROR) in
      
      if let networkError = ERROR {
        let errorString = "Network Error: \(networkError.localizedDescription)"
        completionHandler(uniqeKey: nil, errorString: errorString)
        return
      }
      
      if let data = DATA as? NSData {
        let json = JSON(data: self.stripUdacityData(data))
        
        if let responseError = json["error"].string {
          //TODO: strip "trails.Error 4xx"?
          completionHandler(uniqeKey: nil, errorString: "Login Error: \(responseError)")
          return
        }
        
        if let key = json["account"]["key"].string {
          User.sharedInstance.info.uniqueKey = key
          completionHandler(uniqeKey: key, errorString: nil)
          return
        }
      }
      completionHandler(uniqeKey: nil, errorString: "Data Error: Unique Key Unavailable")
    }
  }
  
  func getUserData(uniqeKey: String, completionHandler: (success: Bool, errorString: String?) -> Void ) {

    Alamofire.request(Router.UdacityInfo(uniqeKey)).response() {
      (_, _, DATA, ERROR) in

      if let networkError = ERROR {
        let errorString = "Network Error: \(networkError.localizedDescription)"
        completionHandler(success: false, errorString: errorString)
        return
      }

      if let data = DATA as? NSData {
        let json = JSON(data: self.stripUdacityData(data))

        if let responseError = json["error"].string {
          //TODO: strip "trails.Error 4xx"?
          completionHandler(success: false, errorString: "Login Error: \(responseError)")
          return
        }

        if let firstname = json["user"]["first_name"].string,
        lastname = json["user"]["last_name"].string {
          User.sharedInstance.info.firstName = firstname
          User.sharedInstance.info.lastName = lastname
          completionHandler(success: true, errorString: nil)
          return
        }
      }
      completionHandler(success: false, errorString: "Data Error: User Info Unavailable")
    }
  }

  //MARK: - Data handlers
  func stripUdacityData(data: NSData, withRange range: Int = 5) -> NSData {
    return data.subdataWithRange(NSMakeRange(range, data.length - range))
  }

  //MARK: - Logout & Session Cleanup
  func invalidateToken() {

  }
  
}
