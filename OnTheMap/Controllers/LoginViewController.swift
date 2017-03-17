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
    
    emailField.delegate = self
    passwordField.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)),
                                           name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)),
                                           name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    navigationController?.navigationBar.isHidden = false
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  @IBAction func doLogin(_ sender: UIButton) {
    
//    self.performSegue(withIdentifier: "loginToMain", sender: nil)
//    return
    
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
        guard error == nil, info != nil else {
          return
        }
        appDelegate.currentStudentInformation = info
      })
      
      UdacityApiClient.sharedInstance.getPublicUserData("\(accountKey)", { (error) in
        
      })
      
      DispatchQueue.main.async {
        self.launchMainView()
      }
    }
    
  }
  
  func launchMainView() {
    let viewController = storyboard?.instantiateViewController(withIdentifier: "main") as! UITabBarController
    present(viewController, animated: true)
  }
  
  @objc func keyboardWillAppear(_ notification: Notification) {
    let keyboardRect = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
    if keyboardRect != nil {
      view.frame.origin.y = -keyboardRect!.height
    }
  }
  @objc func keyboardWillDisappear(_ notification: Notification) {
    view.frame.origin.y = 0
  }
  
}

// MARK: - TextField delegate
extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.tag == 999 {
      passwordField.becomeFirstResponder()
      return true
    }
    textField.resignFirstResponder()
    doLogin(UIButton())
    return true
  }
  
}

