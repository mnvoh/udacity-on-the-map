//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/17/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController {
  
  // MARK: - IBOutlet
  
  @IBOutlet weak var map: MKMapView!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var inputsWrapper: UIView!
  @IBOutlet weak var locationField: UITextField!
  @IBOutlet weak var mediaUrlField: UITextField!
  @IBOutlet weak var findButton: ButtonWithPadding!
  @IBOutlet weak var findButtonWrapper: UIView!
  @IBOutlet weak var inputsWrapperTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var findButtonAcitivtyIndicator: UIActivityIndicatorView!
  
  
  // MARK: - Properties
  let activeColor = #colorLiteral(red: 0.07450980392, green: 0.2549019608, blue: 0.4431372549, alpha: 1)
  let inactiveColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
  let animationDuration = 0.5
  
  var selectedLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  
  /// Indicates whether a location had been entered and found or not
  var inMapMode: Bool = false {
    didSet {
      if inMapMode {
        // if the state has been changed to map mode, adjust the UI accordingly
        mediaUrlField.isHidden = false
        findButton.setTitle("Submit", for: .normal)
        cancelButton.setTitle("Edit Location", for: .normal)
        self.cancelButton.setTitleColor(self.inactiveColor, for: .normal)
        UIView.animate(withDuration: animationDuration, animations: {
          self.inputsWrapperTopConstraint.constant = -(self.view.frame.height * 0.6)
          self.view.layoutIfNeeded()
          self.findButtonWrapper.backgroundColor = self.inactiveColor.withAlphaComponent(0.35)
        })
      }
      else {
        // if the state has been changed to location input mode, adjust the UI
        mediaUrlField.isHidden = true
        findButton.setTitle("Find on the Map", for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.setTitleColor(self.activeColor, for: .normal)
        UIView.animate(withDuration: animationDuration, animations: {
          self.inputsWrapperTopConstraint.constant = 0
          self.view.layoutIfNeeded()
          self.findButtonWrapper.backgroundColor = self.inactiveColor.withAlphaComponent(1)
        })
      }
    }
  }
  
  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  // MARK: - IBActions
  @IBAction func cancel(_ sender: UIButton) {
    if inMapMode {
      inMapMode = false
    }
    else {
      dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction func confirmAction(_ sender: ButtonWithPadding) {
    if !inMapMode {
      findButtonAcitivtyIndicator.isHidden = false
      let geocoder = CLGeocoder()
      geocoder.geocodeAddressString(locationField.text!) { (placemarks: [CLPlacemark]?, error: Error?) in
        if error != nil {
          self.findButtonAcitivtyIndicator.isHidden = true
          self.present(Utils.alert(title: "Place not found", message: "Could not find the place you were looking for!"),
                       animated: true, completion: nil)
          return
        }
        
        guard let placemarks = placemarks else { return }
        
        if placemarks.count <= 0 {
          self.findButtonAcitivtyIndicator.isHidden = true
          self.present(Utils.alert(title: "Place not found", message: "Could not find the place you were looking for!"),
                       animated: true, completion: nil)
          return
        }
        
        let placemark = placemarks[0]
        
        self.selectedLocation = (placemark.location?.coordinate)!
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.selectedLocation
        annotation.title = self.locationField.text
        self.map.removeAnnotations(self.map.annotations)
        self.map.addAnnotation(annotation)
        var distance = CLLocationDistance()
        distance.add(4000.0)
        let region = MKCoordinateRegionMakeWithDistance(self.selectedLocation, distance, distance)
        self.map.setRegion(region, animated: true)
        
        self.findButtonAcitivtyIndicator.isHidden = true
        self.inMapMode = true
      }
    }
    
  }
  
}


// MARK: - Public/private functions
extension PostViewController {
  
  
  
}
