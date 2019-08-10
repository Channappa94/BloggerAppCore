//
//  ViewController.swift
//  BloggerAppCore
//
//  Created by IMCS2 on 8/8/19.
//  Copyright © 2019 com.phani. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var selectedName: String = ""
    var label: String = ""
    var lab: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            let https = "https" + selectedName.dropFirst(4)
            let url = NSURL(string: https)
            let urlrequest  = URLRequest(url: url! as URL)
            webView.load(urlrequest)
        }else{
            print("Internet Connection not Available!")
            let url =  "No internet. Please check the internet connection on your laptop"
            // let request = NSURLRequest(URL: url)
            webView.loadHTMLString(url, baseURL: nil)
        }
        
        
    }
    
}

