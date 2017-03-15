//
//  SingupViewController.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/15/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var webview: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!)
        webview.loadRequest(request)
    }

}
