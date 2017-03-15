//
//  UdacityApiClient.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/15/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation

/// This class abstracts the calls made to client for requests made
/// to the Udacity API endpoints
class UdacityApiClient: Client {
    
    /// singleton
    static let sharedInstance = UdacityApiClient()
    
    /// enforce singleton, prevent initialization outside
    private override init() {}
    
    func login(email: String, password: String, _ completionHandler: (Void) -> Void) {
        let url = Endpoints.Base.udacity + Endpoints.UdacityActions.session
        
        let params = [
            "udacity": [
                "username": email,
                "password": password
            ]
        ]
        
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        post(url, body: params, headers: headers) { (data, response, error) in
            guard let data = data else {
                // TODO: error
                return
            }
            
            let range = Range(0 ..< 5)
            let subData = data.subdata(in: range)
            let json = JSONSerialization.jsonObject(with: subData, options: .allowFragments)
            print(json)
        }
    }
}
