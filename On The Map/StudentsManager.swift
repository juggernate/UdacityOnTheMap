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

class StudentsManager: NSObject {
  //singleton in Swift 1.2
  static let sharedInstance = StudentsManager()
  var students = [Student]()
  
  func updateStudentsList(results: [JSON], completionHandler:([Student])->Void) {
    if results.count < 1 {
      return
    }
    
    self.students.removeAll(keepCapacity: true)
    
    //results appear to come back newest last for now, cheap (but not best) way to order newest first is reverse results
    for student in results.reverse() {
      
      if let firstName = student["firstName"].string,
        lastName = student["lastName"].string,
        latitude = student["latitude"].double,
        longitude = student["longitude"].double,
        objectId = student["objectId"].string, //this is unique auto-generated from Parse for each entry
        mediaURL = student["mediaURL"].string,
        uniqueKey = student["uniqueKey"].string
      {
//        println("\(objectId) Student \(uniqueKey) -- \(firstName) \(lastName) is at lat:\(latitude) lon:\(longitude) shared: \(mediaURL)")
        
        var student = Student()
        student.firstName = firstName
        student.lastName = lastName
        student.latitude = latitude
        student.longitude = longitude
        student.mediaURL = mediaURL
        student.uniqueKey = uniqueKey
        students.append(student)
      }
    }
    
    completionHandler(self.students)
  }
  
  func updateStudentsList(completionHandler:([Student])->Void) {

    Alamofire.request(UdacityClient.Router.Parse).responseJSON() {
      (_, _, DATA, ERROR) in
  
      if let networkError = ERROR {
        //TODO: add display error
        return
      }
      
      if let data: AnyObject = DATA {
        let json = JSON(data)
        if let results = json["results"].array {
          self.updateStudentsList(results, completionHandler:completionHandler)
        }
      } else {
        //display error?
      }
    }
  }
  
}