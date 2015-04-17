//
//  User.swift
//  On The Map
//
//  Created by Nathan Allison on 4/10/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import Foundation

class User {
  //rename Student class to something more intuitive...or just StudentLocation?
  var info = Student()
  static let sharedInstance = User()
  
  func hardCodeFakers() {
    self.info.firstName = "Uncle"
    self.info.lastName = "Carbuncle"
    self.info.mapString = "DingleBerry, Utah"
    self.info.mediaURL = "http://iboopedya.ytmnd.com/"
    self.info.uniqueKey = "4815162342"
  }
  
}
