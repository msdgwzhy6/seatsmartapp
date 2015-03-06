//
//  Util.swift
//  SeatSmart
//
//  Created by Huey Ly on 3/2/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import Foundation

class Util {
    class func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    class func getWebImage(imageUrl:String, callback: (result: UIImage)->()) {
        let url = NSURL(string: imageUrl)
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            if error == nil {
                println("There was an error")
            } else {                
                var image = UIImage(data: data)
                callback(result: image!)
            }
        })
    }
}