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
  var data = [StudentInformation]()
  
  struct Storyboard {
    static let locationTableCellId = "locationCell"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
}

// MARK: - UITableView Datasource
extension ListViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.locationTableCellId)
    
    if let imageView = cell?.imageView, let label = cell?.textLabel {
      imageView.image = #imageLiteral(resourceName: "pin")
      label.text = data[indexPath.row].firstName + " " + data[indexPath.row].lastName
    }
    
    return cell!
  }
  
}
