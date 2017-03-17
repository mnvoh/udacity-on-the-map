//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/16/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
  
  // MARK: - Properties
  
  struct Storyboard {
    static let locationTableCellId = "locationCell"
    static let postViewId = "postLocationView"
    static let loginViewId = "loginView"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadData()
  }
  
  // MARK: - IBActions
  
  @IBAction func logout(_ sender: UIBarButtonItem) {
    UdacityApiClient.sharedInstance.logout { (error) in
      DispatchQueue.main.async {
        if let error = error {
          let alert = Utils.alert(title: "Error", message: error)
          self.present(alert, animated: true, completion: nil)
          return
        }
        let loginView = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.loginViewId)
          as! LoginViewController
        self.present(loginView, animated: true, completion: nil)
      }
    }
  }
  
  @IBAction func postLocation(_ sender: Any) {
    func showPostView() {
      let postView = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.postViewId)
        as! PostViewController
      self.modalTransitionStyle = .coverVertical
      self.modalPresentationStyle = .fullScreen
      self.present(postView, animated: true, completion: nil)
    }
    
    if (UIApplication.shared.delegate as! AppDelegate).currentStudentInformation != nil {
      let alertController = UIAlertController(title: "Overwrite?", message: "Overwrite your current posted location?",
                                              preferredStyle: .alert)
      let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      let actionOk = UIAlertAction(title: "OK", style: .destructive) { (action) in
        showPostView()
      }
      alertController.addAction(actionCancel)
      alertController.addAction(actionOk)
      
      present(alertController, animated: true, completion: nil)
    }
    else {
      showPostView()
    }
  }
  
  @IBAction func refresh(_ sender: Any) {
    loadData()
  }
  
}

// MARK: - public functions
extension ListViewController {
  
  func openUrl(url: String) {
    guard let _url = URL(string: url) else {
      present(Utils.alert(title: "Invalid URL", message: "The provided URL is invalid"), animated: true, completion: nil)
      return
    }
    UIApplication.shared.open(_url, options: [:], completionHandler: nil)
  }
  
}

// MARK: - UITableView Datasource
extension ListViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return StudentInformations.data.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.locationTableCellId)
    
    if let imageView = cell?.imageView, let label = cell?.textLabel {
      imageView.image = #imageLiteral(resourceName: "pin")
      label.text = StudentInformations.data[indexPath.row].firstName + " " +
        StudentInformations.data[indexPath.row].lastName
    }
    
    return cell!
  }
  
}

// MARK: - UITableView Delegate
extension ListViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let info = StudentInformations.data[indexPath.row]
    openUrl(url: info.mediaUrl)
  }
  
}

// MARK: - Private Functions
extension ListViewController {
  
  fileprivate func loadData() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    ParseApiClient.sharedInstance.getLocations { (locations, error) in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      
      if let error = error {
        DispatchQueue.main.async {
          self.present(Utils.alert(title: "Error", message: error), animated: true, completion: nil)
        }
        return
      }
      
      guard let locations = locations else { return }
      DispatchQueue.main.async {
        StudentInformations.data = locations
      }
    }
  }
}
