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
  
  let pinImage = UIImage(named: "PinIcon")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    
    updateStudenList()
    
  }
  
  @IBAction func logout() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  
  @IBAction func updateStudenList() {
    StudentsManager.sharedInstance.updateStudentsList{ students in
      self.makeAnnotations(students)
    }
  }
  
  func makeAnnotations(students: [Student]){
    
    var annotations = [MKPointAnnotation]()
    
    for student in students {
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
    self.mapView.removeAnnotations(self.mapView.annotations)
    self.mapView.addAnnotations(annotations)
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
  
  
  // This delegate method is implemented to respond to taps. It opens the system browser
  // to the URL specified in the annotationViews subtitle property.
  func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
    if control == annotationView.leftCalloutAccessoryView {
      
      if let urlString = annotationView.annotation.subtitle,
        url = NSURL(string: urlString) {
          let request = NSURLRequest(URL: url)
          let webVC = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
          webVC.urlRequest = request
          webVC.navTitle = "Student URL"
          //put it in a navController to use title/cancel
          let webVCNav = UINavigationController()
          webVCNav.pushViewController(webVC, animated: false)
          self.presentViewController(webVCNav, animated: true, completion: nil)
      }
    }
  }
  
}
