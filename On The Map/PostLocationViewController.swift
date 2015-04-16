//
//  PostLocationViewController.swift
//  On The Map
//
//  Created by Nathan Allison on 4/9/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON

class PostLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var locationEntryField: UITextField!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var locateButton: UIButton!
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  //    @IBOutlet weak var lowerButtonTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomHeight: NSLayoutConstraint!
  @IBOutlet weak var bottomOffset: NSLayoutConstraint!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var whereLabel: UILabel!
  
  @IBOutlet weak var topLabelGrp: UIView!
  @IBOutlet weak var shareLocation: UIBarButtonItem!
  
  
  var placemark: CLPlacemark!
  
  let pinImage = UIImage(named: "PinIcon")
//  [UIColor colorWithRed:0.62 green:0.77 blue:0.91 alpha:1.0]
  let urlBackgroudColor = UIColor(red: 0.62, green: 0.77, blue: 0.91, alpha: 1.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    locationEntryField.delegate = self
    //        locationEntryField.delegate = self
    //        locateButton.enabled = false
    // Do any additional setup after loading the view.
    //        self.topConstraint.constant -= self.view.bounds.height
    //        self.topConstraint.constant -= 40
    self.bottomHeight.constant = self.view.bounds.height * 0.8
//    self.view.layoutIfNeeded()
    
    //debug data when bypassing login
    if User.sharedInstance.info.uniqueKey == "" {
      User.sharedInstance.info.firstName = "Gruncle"
      User.sharedInstance.info.lastName = "Carbuncle"
      User.sharedInstance.info.mapString = "DingleBerry, DongKong"
      User.sharedInstance.info.mediaURL = "http://iboopedya.ytmnd.com/"
      User.sharedInstance.info.uniqueKey = "4815162342"
    }
    
    whereLabel.text = "Where art thou \(User.sharedInstance.info.firstName)?"
    shareLocation.enabled = false
    topLabelGrp.alpha = 1
//    self.view.layoutIfNeeded()
  }
  
  override func viewDidAppear(animated: Bool) {
    
    //        view.removeConstraint(lowerButtonTopConstraint)
    
    
    UIView.animateWithDuration(1, delay: 1,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0.8,
      options: .CurveEaseInOut,
      animations: {
//        self.bottomHeight.constant = self.view.bounds.height * 0.8
        self.topLabelGrp.alpha = 1
        //                self.bottomOffset.constant -= 50
        //                self.topConstraint.constant = self.view.frame.minY
        //                self.lowerButtonTopConstraint.constant += 300
        self.view.layoutIfNeeded()},
      completion: nil)
    
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    if textField.keyboardType == UIKeyboardType.Default {
      geocodeUserText()
    }
    
    if textField.keyboardType == UIKeyboardType.URL {
      postLocation()
    }
    
    return true
  }
  
  func convertTopForURL() {
    //update top label and textField to work with URL entry
    if locationEntryField.isFirstResponder(){
      locationEntryField.resignFirstResponder()
    }
    self.whereLabel.text = "What is thine URL?"
    self.locationEntryField.clearsOnBeginEditing = false
    self.locationEntryField.keyboardType = UIKeyboardType.URL
    self.locationEntryField.placeholder = "http://"
    self.locationEntryField.text = "http://"
  }
  
  func animateTopLayers() {
    
    UIView.animateWithDuration(1, delay: 0,
      usingSpringWithDamping: 0.25,
      initialSpringVelocity: 2.8,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: {
        //                self.bottomHeight.constant = self.view.bounds.height * 0.8
        self.bottomOffset.constant -= self.view.bounds.height * 0.8
//        self.topConstraint.constant -= self.view.bounds.height * 0.2
        self.topLabelGrp.backgroundColor = self.urlBackgroudColor
        //                self.lowerButtonTopConstraint.constant += 300
        self.view.layoutIfNeeded()},
      completion: { (_) in
        self.convertTopForURL()
      }
    )
  }
  
  // MARK: - MKMapViewDelegate
  
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    
    //        println("VIEW FOR ANNOTATION:")
    
    let reuseId = "pin"
    
    var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
    
    if pinView == nil {
      pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      pinView!.canShowCallout = true
//      pinView!.pinColor = MKPinAnnotationColor.Purple
      //            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIButton
      pinView!.leftCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.InfoDark) as! UIButton
    }
    else {
      pinView!.annotation = annotation
    }
    
    pinView?.image = pinImage
    return pinView
  }
  
  // This delegate method is implemented to respond to taps. It opens the system browser
  // to the URL specified in the annotationViews subtitle property.
  func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

    if control == annotationView.leftCalloutAccessoryView {
      let app = UIApplication.sharedApplication()
      app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
    }
  }
  
  // MARK: - IBActions
  
  @IBAction func cancelLocationPost(sender: UIBarButtonItem) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func postLocation(sender: UIBarButtonItem){
    postLocation()
  }
  
  func postLocation() {
    //Check for existing StudentLocation using user.uniqueKey
    User.sharedInstance.info.mediaURL = self.locationEntryField.text
    Alamofire.request(UdacityClient.Router.ParseQuery(User.sharedInstance.info.uniqueKey))
    .responseJSON { (_, res, data, error) in
      //THIS COULD RETURN MULTIPLES IF THE STUDENT POSTED WITHOUT CHECKING
      if let networkerror = error {
        //TOOD: display error
        return
      }
      
      let results = JSON(data!)["results"]
      if results.count > 0 {
        //get the first record and overwrite it
        if let objectId = results[0]["objectId"].string {

          Alamofire.request(UdacityClient.Router.ParsePut(objectId ,User.sharedInstance.info))
          .responseJSON { (_, res, data, error) in
            
            if let networkerror = error {
              //TODO: display error popup
              return // from Put closure
            }
            
//            let json = JSON(data!) // don't need this unless you process it somehow
            self.dismissViewControllerAnimated(true, completion: nil)
            
          }
          return // from top request closure
        }
      }
        
//      println("No records found. POST here")
      Alamofire.request(UdacityClient.Router.ParsePost(User.sharedInstance.info))
      .responseJSON { (_, res, data, error) in

        if let networkerror = error {
          //TODO: display error
          return
        }
//        let json = JSON(data!) // don't need this unless you process it somehow
        self.dismissViewControllerAnimated(true, completion: nil)
          
      }
    }
  }
  
  // MARK: - Geocoding
  
  @IBAction func geocodeUserText(sender: UIButton) {
    if locationEntryField.isFirstResponder(){
      locationEntryField.resignFirstResponder()
    }
    geocodeUserText()
  }
  
  func geocodeUserText() {
    locateButton.enabled = false
    spinner.startAnimating()
    // geocode string in text field
    let geoCoder = CLGeocoder()
    let addressString = locationEntryField.text
    
    geoCoder.geocodeAddressString(addressString) { placemarks, error in
      
      self.spinner.stopAnimating()
      self.locateButton.enabled = true
      
      if let error = error {
        let alert = UIAlertController(title: "Location Error:", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Drats!", style: .Default) { action in
          self.spinner.stopAnimating()
          })
        self.presentViewController(alert, animated: true, completion: nil)
        return
      }
      
      if placemarks.count > 0 {
        //just grab the first result
        self.placemark = placemarks[0] as! CLPlacemark
        let location = self.placemark.location

        //show map view with location
        // instantiate postMapVC and pass it location
        // Create a new variable to store the instance of PlayerTableViewController
        //                let destinationVC = segue.destinationViewController as PlayerTableViewController
        //                destinationVC.programVar = newProgramVar
        User.sharedInstance.info.mapString = addressString
        User.sharedInstance.info.latitude = location.coordinate.latitude
        User.sharedInstance.info.longitude = location.coordinate.longitude
        
        self.animateTopLayers()
        
        //TODO set annotion
        
        var annotations = [MKPointAnnotation]() //Todo: array for showing other students with different icon at same time?
        
        let lat = CLLocationDegrees(User.sharedInstance.info.latitude)
        let long = CLLocationDegrees(User.sharedInstance.info.longitude)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(User.sharedInstance.info.firstName) \(User.sharedInstance.info.lastName)"
        
        annotations.append(annotation)
        
        let span = MKCoordinateSpanMake(10, 10)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)

        self.mapView.addAnnotations(annotations)
        self.shareLocation.enabled = true
        
      }
    }
  }
  

  // MARK: - The end of the line, as far as we go
}
