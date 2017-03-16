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
  var data = [StudentInformation]() {
    didSet {
      updateMap()
    }
  }
  
  // MARK: - Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    map.delegate = self
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
        let loginView = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
        self.present(loginView, animated: true, completion: nil)
      }
    }
    
  }

  @IBAction func postLocation(_ sender: Any) {
  }
  
  @IBAction func refresh(_ sender: Any) {
  }
  
  
}

// MARK: - public functions
extension MapViewController {
  
  func openUrl(url: String) {
    var conformedUrl = url
    if conformedUrl.substring(to: conformedUrl.index(conformedUrl.startIndex, offsetBy: 4)) != "http" {
      conformedUrl = "http://\(url)"
    }
    guard let _url = URL(string: conformedUrl) else {
        return
    }
    UIApplication.shared.open(_url, options: [:], completionHandler: nil)
  }
  
}

// MARK: - MKMapView Delegate
extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseId = "mkpin"
    
    var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
    
    if view == nil {
      view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      view?.canShowCallout = true
      view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    else {
      view?.annotation = annotation
    }
    
    return view
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let annotation = view.annotation, let subtitle = annotation.subtitle else {
      return
    }
    openUrl(url: subtitle!)
  }
  
}

// MARK: - Private Functions
extension MapViewController {
  
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
      print(locations)
      guard let locations = locations else { return }
      self.data = locations
    }
  }
  
  fileprivate func updateMap() {
    map.removeAnnotations(map.annotations)
    
    var annotations = [MKPointAnnotation]()
    
    for item in data {
      let annotation = MKPointAnnotation()
      annotation.title = item.firstName + " " + item.lastName
      annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
      annotation.subtitle = item.mediaUrl
      annotations.append(annotation)
    }
    
    map.addAnnotations(annotations)
  }
  
}
