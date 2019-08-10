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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let https = "https" + selectedName.dropFirst(4)
        let url = NSURL(string: https)
        let urlrequest  = URLRequest(url: url! as URL)
        webView.load(urlrequest)
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            print("Internet Connection not Available!")
        }
        

    }
    
}

