//
//  Constants.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/15/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Defaults {
        
        static let defaultTimeout = 10
        
    }
    
    struct ErrorCodes {
        
        static let invalidRequestBody = 10000
        
    }
    
    struct ErrorMessages {
        
        static let timedOut = "Error trying to connect. Please check your connection and try again."
        static let unknownError = "An unknown error has occured!"
        static let invalidCredentials = "Invalid username and/or password!"
        static let invalidRequestBody = "Invalid Request Body!"
    }
    
}
