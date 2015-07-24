//
//  WebsiteViewController.swift
//  P13
//
//  Created by Joseph June on 7/20/15.
//  Copyright © 2015 Team June. All rights reserved.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController {

    var webView: WKWebView
    var service_id: Int = 0
    var targetaddress: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        getServiceDetails()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getServiceDetails() {
        
        var ServiceDetailsURL = "http://45.55.94.99:8080"
        ServiceDetailsURL = ServiceDetailsURL + "/services/" + String(service_id) + "/?key=website"
        
        
        let request = NSURLRequest(URL: NSURL(string: ServiceDetailsURL)!)
        let urlSession = NSURLSession.sharedSession()
        
        
        let task = urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let output =  JSON(data: data!)
            self.targetaddress = "http://" + String(output[0]["redirect_url"])
            
        
            let url = NSURL(string:self.targetaddress)
            let webviewRequest = NSURLRequest(URL:url!)
            self.webView.loadRequest(webviewRequest)
        
            })
        
            task!.resume()
        
        print("next")

        }
    
    }
