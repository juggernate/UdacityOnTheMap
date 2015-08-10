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

  func filterStudents() -> [Student] {
    let realm = Realm()

    let allStudents = realm.objects(Student).sorted("updatedAt", ascending: false) //newest first
    //If starting sorted by newest, can just add to list when it does NOT contain Student.uniqueKey (Udacity ID)
    var filteredStudents = [Student]()
    for student in allStudents {
      //filter the bunch of these with different uniqueKeys from testing
      //TODO: cleaner filtering checks for incomplete entries?
      if student.firstName == "first" && student.lastName == "last" {
        continue
      }
      if student.firstName == "" && student.lastName == "" {
        continue
      }
      //predicate closure to check if filtered array does not yet contain record with this key
      if !contains(filteredStudents, {$0.uniqueKey == student.uniqueKey}) {
        filteredStudents.append(student)
      }
    }

    return filteredStudents
    
  }
  
  var lastUpdated: NSDate? {
    return Realm().objects(Student).sorted("updatedAt", ascending: false).first?.updatedAt
  }
  
  //TODO: prefetch, call this on startup, call from AppDelegate or loginVC?
  //TODO: when called automatically (or manually?) this should only update after timeout threshold
  // i.e. this gets called when moving back to mapView, but should not get called every time if it was called in last X minutes
  func updateStudents(completionHandler:(errorString: String?)->Void) {

    UdacityClient.sharedInstance.updateStudentsList { json, errorString in
      if let error = errorString {
        completionHandler(errorString: error)
        return
      }
      
      if let results = json {
        let realm = Realm()
        realm.write{
          for studentJSON in results {
            realm.add(Student(json: studentJSON), update: true)
          }
        }
      }

      let filtered = self.filterStudents()
      var removers = [Student]()
      for student in Realm().objects(Student) {
        if !contains(filtered, student) {
          removers.append(student)
        }
      }
      
      Realm().write {
        Realm().delete(removers)
      }

      completionHandler(errorString: nil)
    }
  }
  
}