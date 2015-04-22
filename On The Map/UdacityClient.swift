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
  
  var user = Student()

  var token: String?
  var tokenDate: NSDate?
  let tokenThresholdInDays = 30
  
  //if valid token within date just return success
  //TODO: invalidate token after (date, system reset?)
  //TODO: logout should invalidate token
  
  //MARK: - External Callers
  
  func login(user: String, password: String, completionHandler: (errorString: String?) -> Void ) {
    //getSession
    getSession(user, password: password) { uniqueKey, errorString in
      
      if let error = errorString {
        completionHandler(errorString: error)
        return
      }
      
      if let key = uniqueKey {
        self.user.uniqueKey = key
        self.getUserData(key) { json, errorString in

          if let error = errorString {
            completionHandler(errorString: error)
            return
          }

          if let json = json {
            //TODO: remake student with json constructor?
            if let firstname = json["user"]["first_name"].string,
            lastname = json["user"]["last_name"].string {
              self.user.firstName = firstname
              self.user.lastName = lastname
              completionHandler(errorString: nil)
              return
            }
          }

          completionHandler(errorString: "Error: Unable to create User from Data")

        }
      }
    }
  }
  
  func postLocationToParse(student: Student, completionHandler: (errorString: String?) -> Void ) {
    
    //first check for existing entry using user's uniqueKey
    parseQuery(student.uniqueKey) { (objectId, errorString) in
      
      if let error = errorString {
        completionHandler(errorString: error)
        return
      }
      
      if let entry = objectId {
        self.parsePut(entry, student: student){completionHandler(errorString: $0)}
        return
      }
      
      self.parsePost(student){completionHandler(errorString: $0)}
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
