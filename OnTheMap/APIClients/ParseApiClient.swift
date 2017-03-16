//
//  ParseApiClient.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/15/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation

class ParseApiClient: Client {
  
  /// singleton
  static let sharedInstance = ParseApiClient()
  
  /// enforce singleton, prevent initialization outside
  private override init() {}
  
  func getLocations(_ completionHandler: @escaping ([StudentInformation]?, String?) -> Void) {
    
    let url = Endpoints.Base.parse + Endpoints.ParseAction.studentLocation
    
    let headers = [
      "X-Parse-Application-Id": Constants.parseAppId,
      "X-Parse-REST-API-Key": Constants.parseApiKey
    ]
    
    let params = [
      "limit": "100"
    ]
    
    get(url, parameters: params, headers: headers) { (data, response, error) in
      if let error = error {
        completionHandler(nil, self.process(responseAndError: response, error: error))
        return
      }
      
      guard let data = data else {
        completionHandler(nil, self.process(responseAndError: response, error: error))
        return
      }
      
      do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [AnyHashable: Any]
        if let results = json["results"] {
          var studentInformations = [StudentInformation]()
          for result in results as! [[AnyHashable: Any]] {
            if let studentInfo = StudentInformation.from(object: result) {
              studentInformations.append(studentInfo)
            }
          }
          completionHandler(studentInformations, nil)
          return
        }
      }
      catch {
        completionHandler(nil, Constants.ErrorMessages.unknownError)
        return
      }
      
    }
    
  }
  
  func getStudentLocation(_ uniqueKey: Int, _ completionHandler: @escaping (StudentInformation?, String?) -> Void) {
    
    let url = Endpoints.Base.parse + Endpoints.ParseAction.studentLocation
    
    let headers = [
      "X-Parse-Application-Id": Constants.parseAppId,
      "X-Parse-REST-API-Key": Constants.parseApiKey
    ]
    
    let params = [
      "where": "{\"uniqueKey\":\"\(uniqueKey)\"}",
      "limit": "100"
    ]
    
    get(url, parameters: params, headers: headers) { (data, response, error) in
      if let error = error {
        completionHandler(nil, self.process(responseAndError: response, error: error))
        return
      }
      
      guard let data = data else {
        completionHandler(nil, self.process(responseAndError: response, error: error))
        return
      }
      
      do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [AnyHashable: Any]
        if let results = json["results"] {
          for result in results as! [[AnyHashable: Any]] {
            if let studentInfo = StudentInformation.from(object: result) {
              completionHandler(studentInfo, nil)
            }
            return
          }
        }
      }
      catch {
        completionHandler(nil, Constants.ErrorMessages.unknownError)
        return
      }
      
    }
    
  }
  
  func submitLocation(_ studentInfo: StudentInformation, _ completionHandler: @escaping (String?) -> Void) {
    
    let url = Endpoints.Base.parse + Endpoints.ParseAction.studentLocation
    let headers = [
      "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
      "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
      "Content-Type": "application/json"
    ]

    post(url, body: studentInfo.json, headers: headers) { (data, response, error) in
      if error != nil {
        completionHandler(self.process(responseAndError: response, error: error))
        return
      }
      completionHandler(nil)
    }
    
  }
  
  func updateLocation(_ studentInfo: StudentInformation, _ completionHandler: @escaping (String?) -> Void) {
    
    let url = Endpoints.Base.parse + Endpoints.ParseAction.studentLocation + "/" + studentInfo.objectId
    let headers = [
      "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
      "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
      "Content-Type": "application/json"
    ]
    
    put(url, body: studentInfo.json, headers: headers) { (data, response, error) in
      if error != nil {
        completionHandler(self.process(responseAndError: response, error: error))
        return
      }
      completionHandler(nil)
    }
    
  }
  
}
