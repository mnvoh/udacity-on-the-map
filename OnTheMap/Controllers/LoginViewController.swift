//
//  ViewController.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/14/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var loginButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  
  @IBAction func doLogin(_ sender: UIButton) {
    
    self.performSegue(withIdentifier: "loginToMain", sender: nil)
    return
    
    if emailField.text == "" || passwordField.text == "" {
      present(Utils.alert(title: "Incorrent Credentials", message: "Please enter your username and password"),
              animated: true, completion: nil)
      return
    }
    
    activityIndicator.isHidden = false
    loginButton.isEnabled = false
    
    UdacityApiClient.sharedInstance.login(email: emailField.text!, password: passwordField.text!) {
      (accountKey: Int?, sessionId: String?, error: String?) in
      
      guard let accountKey = accountKey, let sessionId = sessionId else {
        DispatchQueue.main.async {
          self.present(Utils.alert(title: "Login Error", message: error!), animated: true, completion: nil)
          self.loginButton.isEnabled = true
          self.activityIndicator.isHidden = true
        }
        return
      }
      
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.accountKey = accountKey
      appDelegate.sessionId = sessionId
      
      ParseApiClient.sharedInstance.getStudentLocation(accountKey, { (info, error) in
        guard error == nil, info != nil else { return }
        appDelegate.currentStudentInformation = info
      })
      
      DispatchQueue.main.async {
        self.performSegue(withIdentifier: "loginToMain", sender: nil)
      }
    }
    
    
  }
  
}

