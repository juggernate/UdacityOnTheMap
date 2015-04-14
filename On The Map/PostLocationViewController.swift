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

class PostLocationViewController: UIViewController, MKMapViewDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationEntryField.delegate = self
//        locateButton.enabled = false
        // Do any additional setup after loading the view.
//        self.topConstraint.constant -= self.view.bounds.height
//        self.topConstraint.constant -= 40
        self.bottomHeight.constant = self.view.bounds.height * 0.2
        
        whereLabel.text = "Where art thou \(User.sharedInstance.info.firstName)?"
        shareLocation.enabled = false
        topLabelGrp.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        view.removeConstraint(lowerButtonTopConstraint)
        
        
        UIView.animateWithDuration(1, delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: {
                self.bottomHeight.constant = self.view.bounds.height * 0.8
                self.topLabelGrp.alpha = 1
//                self.bottomOffset.constant -= 50
//                self.topConstraint.constant = self.view.frame.minY
//                self.lowerButtonTopConstraint.constant += 300
                self.view.layoutIfNeeded()},
            completion: { whatevs in println("DINGLEBERRY")}
        )

    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        //prep?
//        let destinationVC = segue.destinationViewController as PostMapViewController
//    }
    
    func animateTopLayers() {
        
        UIView.animateWithDuration(1, delay: 0,
            usingSpringWithDamping: 0.25,
            initialSpringVelocity: 2.8,
            options: .CurveEaseInOut,
            animations: {
//                self.bottomHeight.constant = self.view.bounds.height * 0.8
                self.bottomOffset.constant -= self.view.bounds.height * 0.8
                self.topConstraint.constant -= self.view.bounds.height * 0.2
                self.topLabelGrp.alpha = 0
                //                self.lowerButtonTopConstraint.constant += 300
                self.view.layoutIfNeeded()},
            completion: {
                whatevs in println("REMOVED TOP LAYERS")
                self.topLabelGrp.removeFromSuperview()
            }
        )
        
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        //        println("VIEW FOR ANNOTATION:")
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = MKPinAnnotationColor.Purple
            //            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIButton
            pinView!.leftCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.InfoDark) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        println("Control Tapped: \(control)")
        
        if control == annotationView.leftCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        println("YoMoFo. Annotation Selected: \(view)")
    }

    
    @IBAction func cancelLocationPost(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postLocation(sender: UIBarButtonItem) {
        
    }

    @IBAction func geocodeUserText(sender: UIButton) {
        locateButton.enabled = false
        spinner.startAnimating()
        // geocode string in text field
        let geoCoder = CLGeocoder()
        let addressString = locationEntryField.text
        
        geoCoder.geocodeAddressString(addressString) { placemarks, error in

            self.spinner.stopAnimating()
            self.locateButton.enabled = true
            
            if let error = error {
                println("Geocode failed with error: \(error.localizedDescription)")
                
                let alert = UIAlertController(title: "Location Error:", message: error.localizedDescription, preferredStyle: .Alert)
                //                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in println("Clicked OK") }
                alert.addAction(UIAlertAction(title: "Drats!", style: .Default) { action in
                    println("Clicked OK")
                    self.spinner.stopAnimating()
                    })
                self.presentViewController(alert, animated: true) { println("Completed") }
                return
            }
            
            println("Placemarks: \(placemarks.count)")
            if placemarks.count > 0 {
                self.placemark = placemarks[0] as! CLPlacemark
                let location = self.placemark.location
                println(location)
                
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
                
                var annotations = [MKPointAnnotation]()
                
                let lat = CLLocationDegrees(User.sharedInstance.info.latitude)
                let long = CLLocationDegrees(User.sharedInstance.info.longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                var annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(User.sharedInstance.info.firstName) \(User.sharedInstance.info.lastName)"
//                annotation.subtitle = mediaURL
                
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
                
                let span = MKCoordinateSpanMake(10, 10)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                //        }
                
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(annotations)
//                self.mapView.addAnnotation(annotation)
                self.shareLocation.enabled = true
                

            }
        }
    }
    
}
