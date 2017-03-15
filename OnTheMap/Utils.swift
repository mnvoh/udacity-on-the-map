//
//  Utils.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/15/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

/// Utility functions go here
class Utils {
    
    /// Constructs a NSError and returns it
    class func e(_ message: String, reason: String, code: Int) -> Error {
        let userInfo: [AnyHashable: Any] = [
            NSLocalizedDescriptionKey: message,
            NSLocalizedFailureReasonErrorKey: reason
        ]
        return NSError(domain: Bundle.main.bundleIdentifier!, code: code, userInfo: userInfo)
    }
    
    class func alert(title: String, message: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        return alertController
    }
    
}
