//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/26/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.stopAnimating()
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        
        /* Configure the UI */
//        self.configureUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.debugTextLabel.text = ""
    }
    
    // MARK: - Actions
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // pass student object
        
    }
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        
        //Todo: check first for empty fields?
        
        spinner.startAnimating()
        
        Alamofire.request(UdacityClient.Router.UdacityLogin(userField.text, passwordField.text))
            .response() { (_, _, DATA, ERROR) in
                
            if let networkError = ERROR {
                println("SHOWING ERROR:")
                println(networkError.localizedDescription)
                self.displayError(networkError.localizedDescription)
                println("Did it work?")
                return
            }
            
            if let data: AnyObject = DATA{
                //strip the first 5 from data (security thing?)
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                let jsn = JSON(data: newData)
                println("JSNOOOOO")
                println(jsn)
                
                if let loginError = jsn["error"].string {
                    println("Login Error:")
                    println(loginError)
                    //TODO: strip "trails.Error 4xx: " if it exists in message for nicer presentation
                    let alert = UIAlertController(title: "Login Error:", message: loginError, preferredStyle: .Alert)
//                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in println("Clicked OK") }
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { action in
                        println("Clicked OK")
                        self.spinner.stopAnimating()
                        })
                    self.presentViewController(alert, animated: true) { println("Completed") }
                }
                
                if let accountID = jsn["account"]["key"].string {
                    println("ACCOUNT ID:")
                    println(accountID)
                    
                    StudentLocation.sharedInstance.objectID = accountID
                    
                    Alamofire.request(UdacityClient.Router.UdacityInfo(accountID)).response() {(_, _, DATA, ERROR) in
                        if let networkError = ERROR {
                            println("SHOWING ERROR:")
                            println(networkError.localizedDescription)
                            self.displayError(networkError.localizedDescription)
                            println("Did it work?")
                            return
                        }
                        
                        if let data: AnyObject = DATA{
                            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                            let jsn = JSON(data: newData)
                            println("JSNOOOOOWWWWW")
                            println(jsn)
                            
                            if let loginError = jsn["error"].string {
                                println("GET UserInfo Error:")
                                println(loginError)
                                //TODO: strip "trails.Error 4xx: " if it exists in message for nicer presentation
                                let alert = UIAlertController(title: "Login User Error:", message: loginError, preferredStyle: .Alert)
                                //                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in println("Clicked OK") }
                                alert.addAction(UIAlertAction(title: "OK", style: .Default) { action in
                                    println("Clicked OK")
                                    self.spinner.stopAnimating()
                                    })
                                self.presentViewController(alert, animated: true) { println("Completed") }
                            }
                            
//                            if let 
                            
                            if let firstname = jsn["user"]["first_name"].string {
                                if let lastname = jsn["user"]["last_name"].string {
                                    println("Hello \(firstname) \(lastname)!" )
                                    StudentLocation.sharedInstance.firstName = firstname
                                    StudentLocation.sharedInstance.lastName = lastname
                                    self.performSegueWithIdentifier("SignInComplete", sender: self)
                                }
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
       
    // MARK: - LoginViewController
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
//            self.debugTextLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            
            if let errorString = errorString? {
//                self.debugTextLabel.text = errorString
                
                let alertController = UIAlertController(title: "Network Error", message: errorString, preferredStyle: .Alert)
                
//                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
//                    // ...
//                }
//                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    println("Clicked OK")
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    self.spinner.stopAnimating()
                }
            }
        })
    }
    
    func configureUI() {
        /* Configure background gradient */
//        self.view.backgroundColor = UIColor.clearColor()
//        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
//        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
//        var backgroundGradient = CAGradientLayer()
//        backgroundGradient.colors = [colorTop, colorBottom]
//        backgroundGradient.locations = [0.0, 1.0]
//        backgroundGradient.frame = view.frame
//        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        /* Configure header text label */
//        headerTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
//        headerTextLabel.textColor = UIColor.whiteColor()
//
//        /* Configure debug text label */
//        debugTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
//        debugTextLabel.textColor = UIColor.whiteColor()
        
        // Configure login button
//        loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
//        loginButton.highlightedBackingColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
//        loginButton.backingColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
//        loginButton.backgroundColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
//        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
}

