//
//  StudentsManager.swift
//  On The Map
//
//  Created by Nathan Allison on 4/14/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import Foundation
//import Alamofire
//import SwiftyJSON
import RealmSwift


//MARK: NSDate comparable extension
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
  return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }

class StudentsManager: NSObject {
  //singleton in Swift 1.2 with static let
  static let sharedInstance = StudentsManager()

  var students = [Student]()
  
  //TODO: should do filtering here instead of view controllers...?
  //TODO: on tableView enable sort&reverse by date, proximity, alphabetical, and search?
  // IS THIS BAD as a calculated property? I'm not sure this should get rebuilt each time it's accessed
  func filterStudents() -> [Student] {
    let realm = Realm()

    let allStudents = realm.objects(Student).sorted("updatedAt", ascending: false) //newest first
    //If starting sorted by newest, can just add to list when it does NOT contain Student.uniqueKey (Udacity ID)
    var filteredStudents = [Student]()
    for student in allStudents {
      //filter the bunch of these with different uniqueKeys from testing
      if student.firstName == "first" && student.lastName == "last" {
        continue
      }
      //predicate closure to see if filtered array already has student record
      if !contains(filteredStudents, {$0.uniqueKey == student.uniqueKey}) {
        filteredStudents.append(student)
      }
    }

    //TODO: Add this to a separate filtered realm?
    return filteredStudents
    
  }
  
  var lastUpdated: NSDate? {
    return Realm().objects(Student).sorted("updatedAt", ascending: false).first?.updatedAt
  }
  
  //TODO: prefetch this on startup, call from AppDelegate or loginVC?
  func updateStudents(completionHandler:(errorString: String?)->Void) {
    println("Number of Student Posts Before Update: \(Realm().objects(Student).count)")
    self.students = filterStudents()
    
    UdacityClient.sharedInstance.updateStudentsList { json, errorString in
      if let error = errorString {
        completionHandler(errorString: error)
        return
      }
      
      if let results = json {
        let realm = Realm()
        realm.write{
          for studentJSON in results {
            let student = Student(json: studentJSON)
            //update requires primary key be defined
            realm.add(student, update: true)
          }
        }
      }
      completionHandler(errorString: nil)
    }
  }
}