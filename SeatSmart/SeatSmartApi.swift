//
//  SeatSmartApi.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/27/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import Foundation


class SeatSmartApi : NSObject {
    let oauth = OAuthApi()

    func getEventDetails(filter: NSString, callback:(result: AnyObject)->()) {
    
    }
    
    func getEvents(filter: NSString, callback:(result: AnyObject)->()) {
        
        var urlPath : NSString = "seatsmart-test-data.json"
        if (filter != "") {
            urlPath = filter
        }
        
        var url = SeatSmartConfig.ApiUrl + "/" + urlPath
        self.oauth.sendGet(url, callback)
    }
    
    func registerUser(fullName : String, email: String, callback: (result: AnyObject)->()) {
        
        var postData = "fullName=\(fullName)&email=\(email)"
        var url = SeatSmartConfig.ApiUrl + "/testposting.php"
        self.oauth.sendPost(url, postData: postData, callback)
    }
}