//
//  User.swift
//  On The Map
//
//  Created by Nathan Allison on 4/10/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import Foundation

//JSON SAMPLE FROM PARSE
//{
//"mediaURL" : "http:\/\/www.linkedin.com\/in\/jessicauelmen\/en",
//"firstName" : "Jessica",
//"longitude" : -82.75676799999999,
//"uniqueKey" : "872458750",
//"latitude" : 28.1461248,
//"objectId" : "kj18GEaWD8",
//"createdAt" : "2015-02-24T22:27:14.456Z",
//"updatedAt" : "2015-04-01T17:46:23.078Z",
//"mapString" : "Tarpon Springs, FL",
//"lastName" : "Uelmen"
//}

class User {
//    var student: Student
    var info = Student()
    static let sharedInstance = User()

}
