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
}