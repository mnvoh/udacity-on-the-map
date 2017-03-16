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
}
