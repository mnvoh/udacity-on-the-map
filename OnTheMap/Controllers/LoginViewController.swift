//
//  ViewController.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/14/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = Client()
        client.post("http://zeyton.com", body: [
            "Hey": "You",
            "I'm": 26
        ], headers: nil) { (data: Data?, response: URLResponse?, error: Error?) in
            // do nothing
        }
        
    }

}

