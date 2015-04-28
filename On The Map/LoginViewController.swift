//
//  LoginViewController.swift
//

import UIKit
import MapKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
  
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var signupButton: UIButton!
  @IBOutlet weak var userField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var mapView: MKMapView!

  //TODO: add properties for configuration colors etc with @IBDesignable
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    spinner.stopAnimating()
    
    userField.delegate = self
    passwordField.delegate = self
    
    /* Configure tap recognizer */
    var tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
    tapRecognizer.numberOfTapsRequired = 1
    tapRecognizer.delegate = self
    self.view.addGestureRecognizer(tapRecognizer)
    
    /* TODO: Configure the UI */
    self.configureUI()
  }
  
  @IBAction func login() {
    
    self.view.endEditing(true)
    
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

    let signupURL = NSURL(string: "https://www.udacity.com/account/signup")!
    let request = NSURLRequest(URL: signupURL)

    spinner.startAnimating()
    UdacityClient.sharedInstance.checkURL(request) {
      self.spinner.stopAnimating()
      
      if let error = $0 {
        self.displayError(error)
      } else {
        self.presentWebView(request)
      }
    }
  }
  
  func presentWebView(request: NSURLRequest) {
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
    
    //In password field and pressed return/go
    login()
    return true
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  // MARK: - Dismiss Keyboard
  func handleSingleTap(recognizer: UITapGestureRecognizer) {
    println("Ding Dong")
    self.view.endEditing(true)
  }
  
  //MARK: - UIGesture
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    return userField.isFirstResponder() || passwordField.isFirstResponder()
  }
  
  
  
  func configureUI() {
    
//    UIStatusBarStyle.Default
    
    //should define global style stuffs somewheres?
    
    let fieldFont = UIFont(name: "Avenir-Roman", size: 28)
    let fieldPadding = CGFloat(11)
    
    for field in [userField, passwordField]{
      field.font = fieldFont
      field.setTextLeftPadding(fieldPadding)
    }
    
//    FAD961
//    UIColor *aColor = [UIColor colorWithRed:0.976 green:0.831 blue:0.271 alpha:1.000];
//    F76B1C
//    UIColor *aColor = [UIColor colorWithRed:0.965 green:0.588 blue:0.153 alpha:1.000];
    let colorTop = UIColor(red: 0.976, green: 0.831, blue: 0.271, alpha: 1.0).CGColor
    let colorBottom = UIColor(red: 0.965, green: 0.588, blue: 0.153, alpha: 1.0).CGColor
    var gradient = CAGradientLayer()
    gradient.colors = [colorTop, colorBottom]
    gradient.locations = [0.0, 1.0]
    gradient.frame = loginButton.bounds
    loginButton.layer.insertSublayer(gradient, atIndex: 0)
    
    loginButton.layer.cornerRadius = 6
    loginButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 26.0)
    
    loginButton.clipsToBounds = true
    

//    loginButton.
    
    //add blur effect to map
//    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//    
//    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
////    visualEffectView.alpha = 0.8
//    visualEffectView.frame = self.view.bounds
////    self.view.addSubview(visualEffectView)
//    self.view.insertSubview(visualEffectView, aboveSubview: mapView)
    
    /* Configure background gradient */
//    self.view.backgroundColor = UIColor.clearColor()
//    let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
//    let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
//    var backgroundGradient = CAGradientLayer()
//    backgroundGradient.colors = [colorTop, colorBottom]
//    backgroundGradient.locations = [0.0, 1.0]
//    backgroundGradient.frame = view.frame
//    self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    
    /* Configure header text label */
    //        headerTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
    //        headerTextLabel.textColor = UIColor.whiteColor()
    //
    //        /* Configure debug text label */
    //        debugTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
    //        debugTextLabel.textColor = UIColor.whiteColor()
    
    // Configure login button
//    loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
//            loginButton.highlightedBackingColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
//            loginButton.backingColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
//    loginButton.backgroundColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
//    loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
}
}

