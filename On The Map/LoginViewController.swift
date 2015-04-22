//
//  LoginViewController.swift
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var signupButton: UIButton!
  @IBOutlet weak var userField: UITextField!
  @IBOutlet weak var passwordField: UITextField!

  //TODO: add properties for configuration colors etc with @IBDesignable
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    spinner.stopAnimating()
    
    userField.delegate = self
    passwordField.delegate = self
    
    /* TODO: Configure the UI */
    self.configureUI()
  }
  
  @IBAction func login() {
    
    spinner.startAnimating()

    UdacityClient.sharedInstance.login(userField.text, password: passwordField.text) {
      self.spinner.stopAnimating()

      if let error = $0 {
        self.displayError(error)
        return
      }

      self.completeLogin()
    }
  }

  func completeLogin() {
    //TODO: animate fade out elements
    performSegueWithIdentifier("SignInComplete", sender: self)
    userField.text = nil
    passwordField.text = nil
  }
  
  
  
  // MARK: - LoginViewController

  @IBAction func accountSignUp(sender: UIButton) {

    let signupURL = NSURL(string: "https://www.udacity.com/account/auth#!/signin")!
    let request = NSURLRequest(URL: signupURL)

    let webVC = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
    webVC.urlRequest = request
    webVC.navTitle = "Udacity Account Sign Up"

    let webNavVC = UINavigationController()
    webNavVC.pushViewController(webVC, animated: false)
    
    self.presentViewController(webNavVC, animated: true, completion: nil)

  }
  
  func displayError(errorString: String?) {
    
      if let errorString = errorString {
        let alertController = UIAlertController(title: nil, message: errorString, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
      }
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
    self.view.backgroundColor = UIColor.clearColor()
    let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
    let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
    var backgroundGradient = CAGradientLayer()
    backgroundGradient.colors = [colorTop, colorBottom]
    backgroundGradient.locations = [0.0, 1.0]
    backgroundGradient.frame = view.frame
    self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    
    /* Configure header text label */
    //        headerTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
    //        headerTextLabel.textColor = UIColor.whiteColor()
    //
    //        /* Configure debug text label */
    //        debugTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
    //        debugTextLabel.textColor = UIColor.whiteColor()
    
    // Configure login button
    loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
//            loginButton.highlightedBackingColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
//            loginButton.backingColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    loginButton.backgroundColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
}
}

