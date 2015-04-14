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

private let _SharedInstance = StudentsManager()

class StudentsManager: NSObject {
    //singleton?
    var students = [Student]()
    
    class var sharedInstance: StudentsManager {
        return _SharedInstance
    }
    
    func updateStudentsList(results: [JSON]) {
        println("RESULTADANANAS:")
        println(results[0])
        //clear existing
        self.students.removeAll(keepCapacity: true)
        
        for student in results {
            var newStudent = Student()
            if let name = student["firstName"].string {
                newStudent.firstName = name
            }
        }
    }
    
    func updateStudentsList() {
        
        println("CHECKIN CHICKENZ")
        
        Alamofire.request(UdacityClient.Router.Parse).responseJSON() {
            (a, b, DATA, ERROR) in
            
            if let networkError = ERROR {
                println("SHOWING ERROR:")
                println(networkError.localizedDescription)
//                    self.displayError(networkError.localizedDescription)
                println("Did it work?")
                return
            }

            if let data: AnyObject = DATA {
                let json = JSON(data)
                if let results = json["results"].array {
                    self.updateStudentsList(results)
                }
            } else {
                println("NO JSON SO SAD")
            }
        }
    }
    
}