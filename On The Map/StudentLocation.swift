//
//  StudentLocation.swift
//  On The Map
//
//  Created by Nathan Allison on 4/10/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import Foundation

private let _SharedInstance = StudentLocation()

//struct Student {
//    var firstName: String
//    var lastName: String
//    var accountID: String
//}

class StudentLocation {
//    var student: Student
    var firstName = ""
    var lastName = ""
    var objectID = ""
    var uniqueKey = ""
    var latitude = 0.0
    var longitude = 0.0
    var mapString = ""
    var mediaURL = ""
    
    class var sharedInstance: StudentLocation {
        return _SharedInstance
    }
}
