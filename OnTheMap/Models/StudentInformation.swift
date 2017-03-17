//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/15/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation

struct StudentInformation {
  let objectId: String
  let uniqueKey: String
  let firstName: String
  let lastName: String
  let mapString: String
  let mediaUrl: String
  let latitude: Double
  let longitude: Double
  
  init(object: [AnyHashable: Any]) {
    var _objectId: String?
    var _uniqueKey: String?
    var _firstname: String?
    var _lastname: String?
    var _mapString: String?
    var _mediaUrl: String?
    var _latitude: Double?
    var _longitude: Double?
    
    // I spent several hours, of my precious time, wondering what I was doing
    // wrong that I couldn't parse some items. It turns out that the stupid API
    // returns results with different character cases in the keys. For example
    // it's sometimes 'mediaUrl' and sometimes 'mediaURL'
    for (key, value) in object {
      let key = key as! String
      switch key.lowercased() {
      case "objectId".lowercased():
        _objectId = value as? String
        break
      case "uniqueKey".lowercased():
        _uniqueKey = value as? String
        break
      case "firstName".lowercased():
        _firstname = value as? String
        break
      case "lastName".lowercased():
        _lastname = value as? String
        break
      case "mapString".lowercased():
        _mapString = value as? String
        break
      case "mediaURL".lowercased():
        _mediaUrl = value as? String
        break
      case "latitude".lowercased():
        _latitude = value as? Double
        break
      case "longitude".lowercased():
        _longitude = value as? Double
        break
      default:
        break
      }
    }
    
    objectId = _objectId ?? ""
    uniqueKey = _uniqueKey ?? ""
    firstName = _firstname ?? ""
    lastName = _lastname ?? ""
    mapString = _mapString ?? ""
    mediaUrl = _mediaUrl ?? ""
    latitude = _latitude ?? 0.0
    longitude = _longitude ?? 0.0
  }
  
  init(objectId: String, uniqueKey: String, firstName: String, lastName: String, mapString: String,
       mediaUrl: String, latitude: Double, longitude: Double) {
    
    self.objectId = objectId
    self.uniqueKey = uniqueKey
    self.firstName = firstName
    self.lastName = lastName
    self.mapString = mapString
    self.mediaUrl = mediaUrl
    self.latitude = latitude
    self.longitude = longitude
  }
  
  /// Returns the JSON representation of this struct
  var json: String {
    get {
      let mirror = Mirror(reflecting: self)
      var elements = [String]()
      
      for (label, value) in mirror.children {
        guard let label = label, label != "objectId" else { continue }
        if label == "latitude" || label == "longitude" {
          elements.append("\"\(label)\": \(value)")
        }
        else {
          elements.append("\"\(label)\": \"\(value)\"")
        }
      }
      
      return "{ " + elements.joined(separator: ", ") + "}"
    }
  }
}
