//
//  HomeViewController.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/16/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var map: MKMapView!
  
  // MARK: - Properties
  var data = [StudentInformation]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}
