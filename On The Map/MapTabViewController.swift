//
//  MapTabViewController.swift
//  On The Map
//
//  Created by Nathan Allison on 4/9/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit

class MapTabViewController: UITabBarController, UITabBarControllerDelegate
{
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        // present the modal meme editor if dummy tab viewController is selected
        if viewController.title == "MODAL"{
            
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let postEditorNav = storyboard.instantiateViewControllerWithIdentifier("PostEditor") as! PostLocationViewController
            self.presentViewController(postEditorNav, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    
}
