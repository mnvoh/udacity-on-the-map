//
//  Client.swift
//  OnTheMap
//
//  Created by Milad Nozari on 3/15/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation

/// This class handles RESTful api requests
class Client {
    
    /// Makes a GET request to an endpoint
    final func get(_ url: String, parameters params: [String: String], headers httpHeaders: [String: String]!,
              _ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        // append the parameters to the URL
        var stringParams = [String]()
        for (index, value) in params {
            stringParams.append("\(index)=\(value)")
        }
        
        guard let nsUrl = URL(string: url + "?" + stringParams.joined(separator: "&")) else {
            completionHandler(nil, nil, Utils.e("Invalid URL", reason: "The provided URL is invalid", code: 0))
            return
        }
        
        var request = URLRequest(url: nsUrl, cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: TimeInterval(Constants.Defaults.defaultTimeout))
        
        request.httpMethod = "GET"
        
        // add the http headers
        if let httpHeaders = httpHeaders {
            for (index, value) in httpHeaders {
                request.addValue(value, forHTTPHeaderField: index)
            }
        }
        
        // get the session and make the request
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        
        task.resume()
    }

    
    /// Makes a POST request to an endpoint
    final func post(_ url: String, body requestBody: [String: Any], headers httpHeaders: [String: String]!,
              _ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let nsUrl = URL(string: url) else {
            completionHandler(nil, nil, Utils.e("Invalid URL", reason: "The provided URL is invalid", code: 0))
            return
        }
        
        var request = URLRequest(url: nsUrl, cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: TimeInterval(Constants.Defaults.defaultTimeout))
        
        request.httpMethod = "POST"
        
        // add the http headers
        if let httpHeaders = httpHeaders {
            for (index, value) in httpHeaders {
                request.addValue(value, forHTTPHeaderField: index)
            }
        }
        
        // construct the http body
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        catch {
            completionHandler(nil, nil, Utils.e(Constants.ErrorMessages.invalidRequestBody,
                                                reason: Constants.ErrorMessages.invalidRequestBody,
                                                code: Constants.ErrorCodes.invalidRequestBody))
            return
        }
        
        // get the session and make the request
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        
        task.resume()
    }
    
    /// Makes a PUT request to an endpoint
    final func put(_ url: String, body requestBody: [String: Any], headers httpHeaders: [String: String]!,
              _ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let nsUrl = URL(string: url) else {
            completionHandler(nil, nil, Utils.e("Invalid URL", reason: "The provided URL is invalid", code: 0))
            return
        }
        
        var request = URLRequest(url: nsUrl, cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: TimeInterval(Constants.Defaults.defaultTimeout))
        
        request.httpMethod = "PUT"
        
        // add the http headers
        if let httpHeaders = httpHeaders {
            for (index, value) in httpHeaders {
                request.addValue(value, forHTTPHeaderField: index)
            }
        }
        
        // construct the http body
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        catch {
            completionHandler(nil, nil, Utils.e("Invalid request body", reason: "The request body is invalid", code: 0))
            return
        }
        
        // get the session and make the request
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        
        task.resume()
    }
    
    /// Makes a DELETE request to the endpoint at url
    final func delete(_ url: String, headers httpHeaders: [String: String]!,
                   _ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let nsUrl = URL(string: url) else {
            completionHandler(nil, nil, Utils.e("Invalid URL", reason: "The provided URL is invalid", code: 0))
            return
        }
        
        var request = URLRequest(url: nsUrl, cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: TimeInterval(Constants.Defaults.defaultTimeout))
        
        request.httpMethod = "DELETE"
        
        // add the http headers
        if let httpHeaders = httpHeaders {
            for (index, value) in httpHeaders {
                request.addValue(value, forHTTPHeaderField: index)
            }
        }
        
        // get the session and make the request
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        
        task.resume()
    }
    
    final func process(responseAndError response: URLResponse?, error: Error?) -> String {
        
        if let error = error {
            let nsError = error as NSError
            
            switch nsError.code {
            case NSURLErrorTimedOut:
                return Constants.ErrorMessages.timedOut
            case Constants.ErrorCodes.invalidRequestBody:
                return Constants.ErrorMessages.invalidRequestBody
            default:
                break
            }
        }
        
        if let response = response {
            let httpResponse = response as! HTTPURLResponse
            switch httpResponse.statusCode {
            case 403:
                return Constants.ErrorMessages.invalidCredentials
            default:
                return Constants.ErrorMessages.unknownError
            }
        }
        
        return Constants.ErrorMessages.unknownError
    }
}
