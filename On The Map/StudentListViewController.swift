//
//  StudentListViewController.swift
//  On The Map
//
//  Created by Nathan Allison on 4/15/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit
import RealmSwift

class StudentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  let realm = Realm()

  var students = Realm().objects(Student)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self

  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as! UITableViewCell
    
//    let student = StudentsManager.sharedInstance.students[indexPath.row]
    let student = students[indexPath.row]
    cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
    cell.detailTextLabel?.text = student.mediaURL
    
    //TODO: highlight current user's entry?
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
//    let student = StudentsManager.sharedInstance.students[indexPath.row]
    let student = students[indexPath.row]
    if let url = NSURL(string: student.mediaURL) {
      let request = NSURLRequest(URL: url)
      let webVC = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
      webVC.urlRequest = request
      webVC.navTitle = "\(student.firstName) shared:"

      let webVCNav = UINavigationController()
      webVCNav.pushViewController(webVC, animated: false)
      self.presentViewController(webVCNav, animated: true, completion: nil)
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return StudentsManager.sharedInstance.students.count
    return realm.objects(Student).count
  }
  
  
  @IBAction func logout() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func updateStudentList() {
    StudentsManager.sharedInstance.updateStudents{ error in
      if let error = error {
        //display error?
        return
      }
//      self.students.removeAll(keepCapacity: true)
//      for s in Realm().objects(Student).sorted("updatedAt", ascending: false){
//        self.students.append(s)
//      }
      self.students = Realm().objects(Student).sorted("updatedAt", ascending: false)
      self.tableView.reloadData()
    }
  }
  
}
