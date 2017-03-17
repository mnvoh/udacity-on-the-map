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
  
  static func from(object: [AnyHashable: Any]) -> StudentInformation? {
    
    var objectId: String?
    var uniqueKey: String?
    var firstname: String?
    var lastname: String?
    var mapString: String?
    var mediaUrl: String?
    var latitude: Double?
    var longitude: Double?
    
    // I spent several hours, of my precious time, wondering what I was doing
    // wrong that I couldn't parse some items. It turns out that the stupid API
    // returns results with different character cases in the keys. For example
    // it's sometimes 'mediaUrl' and sometimes 'mediaURL'
    for (key, value) in object {
      let key = key as! String
      switch key.lowercased() {
      case "objectId".lowercased():
        objectId = value as? String
        break
      case "uniqueKey".lowercased():
        uniqueKey = value as? String
        break
      case "firstName".lowercased():
        firstname = value as? String
        break
      case "lastName".lowercased():
        lastname = value as? String
        break
      case "mapString".lowercased():
        mapString = value as? String
        break
      case "mediaURL".lowercased():
        mediaUrl = value as? String
        break
      case "latitude".lowercased():
        latitude = value as? Double
        break
      case "longitude".lowercased():
        longitude = value as? Double
        break
      default:
        break
      }
    }
    
    if firstname == nil || lastname == nil || mediaUrl == nil {
      print(object)
    }
    
    return StudentInformation(objectId: objectId ?? "",
                              uniqueKey: uniqueKey ?? "",
                              firstName: firstname ?? "",
                              lastName: lastname ?? "",
                              mapString: mapString ?? "",
                              mediaUrl:  mediaUrl ?? "",
                              latitude: latitude ?? 0.0,
                              longitude: longitude ?? 0.0)
  }
}
