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

//  var students = [Student]()

  //TODO: on tableView enable sort&reverse by date, proximity, alphabetical, and search?
  func filterStudents() -> [Student] {
    let realm = Realm()

    let allStudents = realm.objects(Student).sorted("updatedAt", ascending: false) //newest first
    //If starting sorted by newest, can just add to list when it does NOT contain Student.uniqueKey (Udacity ID)
    var filteredStudents = [Student]()
    for student in allStudents {
//      println("\(student.objectID) -- \(student.uniqueKey)")
      //filter the bunch of these with different uniqueKeys from testing
      if student.firstName == "first" && student.lastName == "last" {
        //filteredStudents.append(student)
        continue
      }
      if student.firstName == "" && student.lastName == "" {
        continue
      }
      //predicate closure to see if filtered array already has student record
      if !contains(filteredStudents, {$0.uniqueKey == student.uniqueKey}) {
        filteredStudents.append(student)
      }
    }

    //TODO: Add this to a separate filtered realm?
    println("Number of Student Posts AFTER FILTER (ARRAY): \(filteredStudents.count)")

    return filteredStudents
    
  }
  
  var lastUpdated: NSDate? {
    return Realm().objects(Student).sorted("updatedAt", ascending: false).first?.updatedAt
  }
  
  //TODO: prefetch this on startup, call from AppDelegate or loginVC?
  func updateStudents(completionHandler:(errorString: String?)->Void) {
    println("Number of Student Posts BEFORE Update (REALM): \(Realm().objects(Student).count)")
//    self.students = filterStudents()
    
    UdacityClient.sharedInstance.updateStudentsList { json, errorString in
      if let error = errorString {
        completionHandler(errorString: error)
        return
      }
      
      if let results = json {
        let realm = Realm()
        realm.write{
          for studentJSON in results {
            //update requires primary key be defined
            
            let student = Student(json: studentJSON)
            realm.add(student, update: true)
          }
        }
      }
      
//      println("Number of Student Posts AFTER Update (REALM): \(Realm().objects(Student).count)")
      
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
      
//      println("Realm NOW HAS \(Realm().objects(Student).count) students")

      completionHandler(errorString: nil)
    }
  }
  
}