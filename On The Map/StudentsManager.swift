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

//private let _SharedInstance = StudentsManager()

class StudentsManager: NSObject {
    //singleton
    static let sharedInstance = StudentsManager()
    var students = [Student]()
    
    func updateStudentsList(results: [JSON], completionHandler:([Student])->Void) {
        println("RESULT COUNT: \(results.count)")
        if results.count < 1 {
            return
        }

        self.students.removeAll(keepCapacity: true)
        //println(results[0])
   
        for student in results {
            
            if let firstName = student["firstName"].string,
            lastName = student["lastName"].string,
            latitude = student["latitude"].double,
            longitude = student["longitude"].double,
            objectId = student["objectId"].string,
            mediaURL = student["mediaURL"].string
            {
                println("Student \(objectId) -- \(firstName) \(lastName) is at lat:\(latitude) lon:\(longitude) shared: \(mediaURL)")
                //TODO construct annotation array
                var student = Student()
                student.firstName = firstName
                student.lastName = lastName
                student.latitude = latitude
                student.longitude = longitude
                student.mediaURL = mediaURL
                students.append(student)
            }
            
        }

        completionHandler(self.students)
    }
    
    func updateStudentsList(completionHandler:([Student])->Void) {
        
        println("CHECKIN CHICKENZ")
        
        Alamofire.request(UdacityClient.Router.Parse).responseJSON() {
            (a, b, DATA, ERROR) in
            
//            println(a)
//            println(b)
//            println(DATA)
            
            if let networkError = ERROR {
                println("SHOWING ERROR:")
                println(networkError.localizedDescription)
//                    self.displayError(networkError.localizedDescription)
                println("Did it work?")
                return
            }

            if let data: AnyObject = DATA {
                let json = JSON(data)
                println("Da JSON")
//                println(json)
                if let results = json["results"].array {
                    self.updateStudentsList(results, completionHandler:completionHandler)
                }
            } else {
                println("NO JSON SO SAD")
            }
        }
    }
    
}