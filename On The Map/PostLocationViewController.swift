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

class PostLocationViewController: UIViewController {

    @IBOutlet weak var locationEntryField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var locateButton: UIButton!
    
    var placemark: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationEntryField.delegate = self
//        locateButton.enabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        //prep?
//        let destinationVC = segue.destinationViewController as PostMapViewController
//    }

    @IBAction func reverseGeolocate(sender: UIButton) {
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
                StudentLocation.sharedInstance.mapString = addressString
//                StudentLocation.sharedInstance.latitude = 
                
                self.performSegueWithIdentifier("MapPost", sender: self)
                

            }
        }
    }
    
}
