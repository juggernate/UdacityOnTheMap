//
//  LoginViewController.swift
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var signupButton: UIButton!
  @IBOutlet weak var userField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
//  var appDelegate: AppDelegate!
//  var session: NSURLSession!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    spinner.stopAnimating()
    
    userField.delegate = self
    passwordField.delegate = self
    /* Get the app delegate */
//    appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    /* Get the shared URL session */
//    session = NSURLSession.sharedSession()
    
    /* Configure the UI */
    //        self.configureUI()
  }
  
  @IBAction func login(sender: AnyObject) {
    login()
  }
  
  func login() {
    
    spinner.startAnimating()
    
    Alamofire.request(UdacityClient.Router.UdacityLogin(userField.text, passwordField.text))
      .response() { (_, _, DATA, ERROR) in
        
        if let networkError = ERROR {
          println("SHOWING ERROR:")
          println(networkError.localizedDescription)
          self.displayError(networkError.localizedDescription)
          return
        }
        
        if let data: AnyObject = DATA{
          //strip the first 5 from data (security thing?)
          let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
          let jsn = JSON(data: newData)
          
          if let loginError = jsn["error"].string {
            println("Login Error:")
            println(loginError)
            //TODO: strip "trails.Error 4xx: " if it exists in message for nicer presentation
            let alert = UIAlertController(title: "Login Error:", message: loginError, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { action in
              println("Clicked OK")
              self.spinner.stopAnimating()
              })
            self.presentViewController(alert, animated: true) { println("Completed") }
          }
          
          if let accountID = jsn["account"]["key"].string {
            println("ACCOUNT ID:")
            println(accountID)
            
            User.sharedInstance.info.uniqueKey = accountID
            
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
                
                if let loginError = jsn["error"].string {
                  println("GET UserInfo Error:")
                  println(loginError)
                  //TODO: strip "trails.Error 4xx: " if it exists in message
                  let alert = UIAlertController(title: "Login User Error:", message: loginError, preferredStyle: .Alert)
                  alert.addAction(UIAlertAction(title: "OK", style: .Default) { action in
                    println("Clicked OK")
                    self.spinner.stopAnimating()
                    })
                  self.presentViewController(alert, animated: true) { println("Completed") }
                }
                
                if let firstname = jsn["user"]["first_name"].string,
                  lastname = jsn["user"]["last_name"].string {
                    println("Hello \(firstname) \(lastname)! AKA \(accountID)" )
                    User.sharedInstance.info.firstName = firstname
                    User.sharedInstance.info.lastName = lastname
                    self.performSegueWithIdentifier("SignInComplete", sender: self)
                }
              }
            }
          }
        }
    }
  }
  
  
  
  // MARK: - LoginViewController
  
//  func completeLogin() {
//    dispatch_async(dispatch_get_main_queue()) {
//      let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
//      self.presentViewController(controller, animated: true, completion: nil)
//    }
//  }
  
  @IBAction func accountSignUp(sender: UIButton) {
    
    //TODO: refactor name
    let signupURL = NSURL(string: "https://www.udacity.com/account/auth#!/signin")!
    //        UIApplication.sharedApplication().openURL(signupURL)
    let request = NSURLRequest(URL: signupURL)
    
    //        let authorizationURL = NSURL(string: "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)")
    //        let request = NSURLRequest(URL: authorizationURL!)
    let webAuthViewController = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
    webAuthViewController.urlRequest = request
    webAuthViewController.navTitle = "Udacity Account Sign Up"
    //        webAuthViewController.requestToken = requestToken
    //        webAuthViewController.completionHandler = completionHandler
    
    //put it in a navController so you can automatically have navBar...
    let webAuthNavigationController = UINavigationController()
    webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
    
    dispatch_async(dispatch_get_main_queue(), {
      self.presentViewController(webAuthNavigationController, animated: true, completion: nil)
    })
    
  }
  
  func displayError(errorString: String?) {
    dispatch_async(dispatch_get_main_queue(), {
      
      if let errorString = errorString {
        //                self.debugTextLabel.text = errorString
        
        let alertController = UIAlertController(title: "Network Error", message: errorString, preferredStyle: .Alert)
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
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == userField {
      passwordField.becomeFirstResponder()
      return true
    }
    
    login()
    return true
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

