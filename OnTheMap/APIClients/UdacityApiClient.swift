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
    
    let params = "{ \"udacity\": { \"username\": \"\(email)\", \"password\": \"\(password)\" } }"
    
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
        completionHandler(nil, nil, error.localizedDescription)
        return
      }
    }
  }
  
  /// Logs out the current user
  func logout(_ completionHandler: @escaping (String?) -> Void) {
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
      if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    
    guard let cookie = xsrfCookie else {
      completionHandler(Constants.ErrorMessages.cookieNotFound)
      return
    }
    
    let headers = [
      "X-XSRF-TOKEN": cookie.value
    ]
    
    delete(Endpoints.Base.udacity + Endpoints.UdacityActions.session, headers: headers) { (data, response, error) in
      if let error = error {
        completionHandler(self.process(responseAndError: response, error: error))
        return
      }
      
      completionHandler(nil)
    }
  }
  
  func getPublicUserData(_ id: String, _ completionHandler: @escaping (String?) -> Void) {
    
    let url = Endpoints.Base.udacity + Endpoints.UdacityActions.users + "/\(id)"
    
    get(url, parameters: [:], headers: nil) { (data, response, error) in
      guard let data = data else {
        print(error)
        completionHandler(self.process(responseAndError: response, error: error))
        return
      }
      
      let range = Range(5 ..< data.count)
      let subData = data.subdata(in: range)
      do {
        let json = try JSONSerialization.jsonObject(with: subData, options: .allowFragments)
          as! [AnyHashable: Any]
        
        guard let user = json["user"] as? [AnyHashable: Any] else { return }
        
        let firstname = user["first_name"] as? String
        let lastname = user["last_name"] as? String
        
        let appd = UIApplication.shared.delegate as! AppDelegate
        appd.firstname = (firstname != nil) ? firstname! : ""
        appd.lastname = (lastname != nil) ? lastname! : ""
        print(firstname, lastname)
      }
      catch {
        completionHandler(error.localizedDescription)
      }
    }
    
  }
}
