//
//  Endpoints.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/15/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation

struct Endpoints {
    
    struct Base {
        
        static let udacity = "https://www.udacity.com/api/"
        static let parse = "https://parse.udacity.com/parse/classes/"
        
    }
    
    /// Udacity Paths
    struct UdacityActions {
        
        static let session = "session"
        static let users = "users"
        
    }
    
    /// Parse Paths
    struct ParseAction {
        
        static let studentLocation = "StudentLocation"
        
    }
    
}
