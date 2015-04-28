//
//  MapViewController.swift
//  On The Map
//
//  Created by Nathan Allison on 3/30/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

// TODO: Move locations request/response into separate model, map and list view should pull from that single source

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  let pinImage = UIImage(named: "PinIcon")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    
    updateStudenList()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    updateStudenList()
  }
  
  @IBAction func logout() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  
  @IBAction func updateStudenList() {
//    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    refreshButton.enabled = false
    spinner.startAnimating()
    StudentsManager.sharedInstance.updateStudents(){ error in
      self.spinner.stopAnimating()
      self.refreshButton.enabled = true
      if let error = error {
        //display error
        self.displayError(error)
        return
      }
      self.makeAnnotations()
    }
    
  }
  
  func makeAnnotations(){
    
    var annotations = [MKPointAnnotation]()
    
    for student in StudentsManager.sharedInstance.students {
      
      let lat = CLLocationDegrees(student.latitude)
      let long = CLLocationDegrees(student.longitude)
      
      // The lat and long are used to create a CLLocationCoordinates2D instance.
      let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
      
      let first = student.firstName
      let last = student.lastName
      let mediaURL = student.mediaURL
      
      var annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      annotation.title = "\(first) \(last)"
      annotation.subtitle = mediaURL
      annotations.append(annotation)
      
    }
    
    if annotations.count > 0 {
      self.mapView.removeAnnotations(self.mapView.annotations)
      self.mapView.addAnnotations(annotations)
    }
    
  }
  
  // MARK: - MKMapViewDelegate
  
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    
    let reuseId = "pin"
    
    var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
    
    if pinView == nil {
      pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      pinView!.canShowCallout = true
      pinView!.pinColor = .Purple
      pinView!.leftCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton//

    }
    else {
      pinView!.annotation = annotation
    }
    
    pinView?.image = pinImage
    //TODO: align callout / or align image to callout?
    return pinView
  }
  
  func presentWebView(request: NSURLRequest) {
    let webVC = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
    webVC.urlRequest = request
    webVC.navTitle = "Student URL"
    
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
  
  // This delegate method is implemented to respond to taps. It opens the system browser
  // to the URL specified in the annotationViews subtitle property.
  func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
    if control == annotationView.leftCalloutAccessoryView {
      
      if let urlString = annotationView.annotation.subtitle,
      url = NSURL(string: urlString) {
        let request = NSURLRequest(URL: url)
        
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
    }
  }
  
}
