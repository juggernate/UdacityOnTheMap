//
//  StudentListViewController.swift
//  On The Map
//
//  Created by Nathan Allison on 4/15/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    //update student list if empty?
    //        updateStudentList(sender: nil)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as! UITableViewCell
    //        let meme = memes[indexPath.row]
    
    let student = StudentsManager.sharedInstance.students[indexPath.row]
    cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
    cell.detailTextLabel?.text = student.mediaURL
    //        cell.imageView?.image = meme.memeImage
    //        cell.textLabel?.text = meme.topLabel
    //        cell.detailTextLabel?.text = meme.bottomLabel
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let student = StudentsManager.sharedInstance.students[indexPath.row]
    if let url = NSURL(string: student.mediaURL) {
      let request = NSURLRequest(URL: url)
      println(request)
      let webVC = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
      webVC.urlRequest = request
      webVC.navTitle = "\(student.firstName) shared:"
      //put it in a navController to use title/cancel
      let webVCNav = UINavigationController()
      webVCNav.pushViewController(webVC, animated: false)
      self.presentViewController(webVCNav, animated: true, completion: nil)
    }
    
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return StudentsManager.sharedInstance.students.count
  }
  
  @IBAction func updateStudentList(sender: UIBarButtonItem) {
    updateStudenList()
  }
  
  func updateStudenList() {
    StudentsManager.sharedInstance.updateStudentsList{ students in
      println("GOT THE STUDENTS BACK")
      //      self.makeAnnotations(students)
      //TODO update stuffs tableView here
      self.tableView.reloadData()
      
    }
  }
  
}
