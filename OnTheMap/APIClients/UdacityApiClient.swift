//
//  UdacityApiClient.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/15/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation
import UIKit

/// This class abstracts the calls made to client for requests made
/// to the Udacity API endpoints
class UdacityApiClient: Client {
    
    /// singleton
    static let sharedInstance = UdacityApiClient()
    
    /// enforce singleton, prevent initialization outside
    private override init() {}
    
    
    /// Takes care of logging in. 
    /// - parameter email: The email
    /// - parameter password: The password
    /// - parameter completionHandler: (accountKey: Int?, sessionId: String?, error: String?) -> Void
    func login(email: String, password: String, _ completionHandler: @escaping (Int?, String?, String?) -> Void) {
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
                completionHandler(nil, nil, self.process(responseAndError: response, error: error))
                return
            }
            
            // as per udacity's instructions, the first 5 bytes of the response
            // are dummy data!
            let range = Range(5 ..< data.count)
            let subData = data.subdata(in: range)
            do {
                let json = try JSONSerialization.jsonObject(with: subData, options: .allowFragments)
                    as! [AnyHashable: Any]
                if let responseError = json["error"] {
                    completionHandler(nil, nil, responseError as? String)
                    return
                }
                
                let account = json["account"] as? [AnyHashable: Any]
                let session = json["session"] as? [AnyHashable: Any]
                
                if account != nil, session != nil {
                    // store the retrieved data in the app delegate
                    let accountKey = Int(account!["key"] as! String)
                    let sessionId = session!["id"] as! String
                    
                    completionHandler(accountKey, sessionId, nil)
                    return
                }
                
                completionHandler(nil, nil, Constants.ErrorMessages.unknownError)
            }
            catch {
                completionHandler(nil, nil, Constants.ErrorMessages.unknownError)
                return
            }
        }
    }
}
