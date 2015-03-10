//
//  SeatSmartApi.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/27/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import Foundation


class SeatSmartApi : NSObject {
    var accessToken: String = ""
    let httpRequest = HTTPRequest()
    
    override init() {
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (prefs.valueForKey("ACCESS_TOKEN") != nil) {
            accessToken = prefs.valueForKey("ACCESS_TOKEN") as String
        }
    }

    func getEventDetails(filter: NSString, callback:(result: AnyObject)->()) {
    
    }
    
    func getEvents(filter: NSString, callback:(result: AnyObject)->()) {
        
        var urlPath : NSString = "seatsmart-test-data.json"
        if (filter != "") {
            urlPath = filter
        }
        
        var url = SeatSmartConfig.ApiUrl + "/" + urlPath
        let requestHeaders = ["Authorization": "Bearer " + accessToken]
        httpRequest.get(url, requestHeaders: requestHeaders, callback)
        
    }
    
    func registerUser(fullName : String, email: String, callback: (result: AnyObject)->()) {
        
        var postData = "fullName=\(fullName)&email=\(email)"
        var url = SeatSmartConfig.ApiUrl + "/testposting.php"
        let requestHeaders = ["Authorization": "Bearer " + accessToken]
        httpRequest.post(url, postData: postData, requestHeaders: requestHeaders, callback)
    }
    
    func getAccessToken(username: String, password: String, callback: (result: AnyObject)->()) {
        var postData = "grant_type=password&username=\(username)&password=\(password)" +
            "&client_id=\(SeatSmartConfig.OAuthClientId)&client_secret=\(SeatSmartConfig.OAuthClientSecret)"
        
        var url = SeatSmartConfig.ApiUrl + "/token"
        var requestHeaders : NSDictionary = Dictionary<String, String>()
        
        httpRequest.post(url, postData: postData, requestHeaders: requestHeaders, callback)
    }
}