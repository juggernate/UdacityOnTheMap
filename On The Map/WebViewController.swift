//
//  WebViewController.swift
//  On The Map
//
//  Created by Nathan Allison on 4/12/15.
//  Copyright (c) 2015 shondicon. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var urlRequest: NSURLRequest? = nil
    var navTitle: String? = nil
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        if navTitle != nil {
            self.navigationItem.title = navTitle
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if urlRequest != nil {
            self.webView.loadRequest(urlRequest!)
        }
    }

    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}