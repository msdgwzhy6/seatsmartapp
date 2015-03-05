//
//  SeatSmartApi.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/27/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import Foundation


class SeatSmartApi : NSObject {

    
    func getEvents(filter: NSString, callback:(result: NSString, error: NSError)->()) {
        
        var urlPath = SeatSmartConfig.ApiUrl + "/" + filter
        self.sendGet(urlPath, callback)
    }
    
    private func sendGet(urlPath: NSString, callback: (result: NSString, error: NSError)->()) {
        let url: NSURL = NSURL(string: urlPath)!
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "GET"

        let encryptedLoginString = self.getEncryptedLoginString()
        request.setValue(encryptedLoginString, forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            println("response = \(response)")
            
            var jsonError: NSError?
            var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSArray
            println("data = \(jsonData)")
        }
        
        task.resume()
    }
    
    private func sendPost(urlPath: NSString, postString: NSString, callback: (result: NSString, error: NSError)->()) {
        
        let url: NSURL = NSURL(string: urlPath)!
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let encryptedLoginString = self.getEncryptedLoginString()
        request.setValue(encryptedLoginString, forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in

            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            callback(result: responseString!, error: error)
        }
        task.resume()
        
    }
    
    private func getEncryptedLoginString() -> String {
        let username = "huey"
        let password = "asdf"
        let loginString = NSString(format: "%@:%@", username, password)
        let encryptedString = self.encryptString(loginString)
        
        return encryptedString
    }
    
    private func encryptString(value : NSString) -> String {
        return value
    }
}