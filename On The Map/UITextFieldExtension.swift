//
//  UITextFieldExtension.swift
//  On The Map
//
//  Created by Nathan Allison on 4/24/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
  func setTextLeftPadding(left:CGFloat) {
    var leftView:UIView = UIView(frame: CGRectMake(0, 0, left, 1))
    leftView.backgroundColor = UIColor.clearColor()
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewMode.Always;
  }
}
