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
        guard let label = label else { continue }
        elements.append("\"\(label)\": \"\(value)\"")
      }
      
      return "{ " + elements.joined(separator: ", ") + "}"
    }
  }
  
  static func from(object: [AnyHashable: Any]) -> StudentInformation? {
    
    if let objectId = object["objectId"] as? String,
      let uniqueKey = object["uniqueKey"] as? String,
      let firstname = object["firstName"] as? String,
      let lastname = object["lastName"] as? String,
      let mapString = object["mapString"] as? String,
      let mediaUrl = object["mediaURL"] as? String,
      let latitude = object["latitude"] as? NSNumber,
      let longitude = object["longitude"] as? NSNumber {
      
      return StudentInformation(objectId: objectId,
                                uniqueKey: uniqueKey,
                                firstName: firstname,
                                lastName: lastname,
                                mapString: mapString,
                                mediaUrl:  mediaUrl,
                                latitude: Double(latitude),
                                longitude: Double(longitude))
    }
    // Incomplete data, so we don't want it
    return nil
    
  }
}
