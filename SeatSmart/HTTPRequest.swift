//
//  OAuthApi.swift
//  SeatSmart
//
//  Created by Huey Ly on 3/6/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import Foundation

class HTTPRequest : NSObject {
    
    func get(urlPath: NSString, requestHeaders: NSDictionary, callback: (result: AnyObject)->()) {
        let url: NSURL = NSURL(string: urlPath)!
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "GET"
        
        
        for (key, value) in requestHeaders {
            let headerName = key as String
            let headerValue = value as String
            request.setValue(headerValue, forHTTPHeaderField: headerName)
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            println("response = \(response)")
            
            var jsonError: NSError?
            var jsonData: AnyObject = [];
            if (data != nil) {
                jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError)!
            }
            println("data = \(jsonData)")
            
            callback(result: jsonData)
        }
        
        task.resume()
    }
    
    func post(urlPath: NSString, postData: NSString, requestHeaders: NSDictionary, callback: (result: AnyObject)->()) {
        
        let url: NSURL = NSURL(string: urlPath)!
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        var postLength:NSString = String( postData.length )
        var request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        for (key, value) in requestHeaders {
            let headerName = key as String
            let headerValue = value as String
            request.setValue(headerValue, forHTTPHeaderField: headerName)
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            println("response = \(response)")
            
            var jsonError: NSError?
            var jsonData: AnyObject = [];
            if (data != nil) {
                jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError)!
            }
            println("data = \(jsonData)")
            
            callback(result: jsonData)
        }
        task.resume()
        
    }
    
    private func getEncryptedLoginString(username: NSString, password: NSString) -> String {
        
        let loginString = NSString(format: "%@:%@", username, password)
        let encryptedString = self.encryptString(loginString)
        
        return encryptedString
    }
    
    private func encryptString(value : NSString) -> String {
        return value
    }
}