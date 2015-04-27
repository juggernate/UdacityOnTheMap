//
//  StudentsManager.swift
//  On The Map
//
//  Created by Nathan Allison on 4/14/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//TODO: Convert this to realm DB

class StudentsManager: NSObject {
  //singleton in Swift 1.2
  static let sharedInstance = StudentsManager()
  var students = [Student]()
  
  func updateStudents(completionHandler:(errorString: String?)->Void) {
    
    UdacityClient.sharedInstance.updateStudentsList { json, errorString in
      if let error = errorString {
        completionHandler(errorString: error)
        return
      }
      
      if let results = json {
        self.students.removeAll(keepCapacity: true)
        //results appear to come back newest last for now, cheap (but not best) way to order newest first is reverse results
        for studentJSON in results.reverse() {
          
          if let firstName = studentJSON["firstName"].string,
            lastName = studentJSON["lastName"].string,
            latitude = studentJSON["latitude"].double,
            longitude = studentJSON["longitude"].double,
            objectId = studentJSON["objectId"].string, //this is unique auto-generated from Parse for each entry
            mediaURL = studentJSON["mediaURL"].string,
            uniqueKey = studentJSON["uniqueKey"].string
          {
            self.students.append(Student(json: studentJSON))
          }
        }
      }
      completionHandler(errorString: nil)
    }
    
  }
  
}