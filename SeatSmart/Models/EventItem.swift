//
//  EventItem.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/15/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit

class EventItem: NSObject {
    var title: String;
    var zip: String;
    var date: String;
    var basePrice: String;
    var latidude: String;
    var longitude: String;
    
    convenience override init() {
        self.init(fromString: "Event Title")
    }
    
    init(fromString title: NSString) {
        self.title = title
        self.zip = ""
        self.date = ""
        self.basePrice = "0.00"
        self.latidude = "0.0"
        self.longitude = "0.0"
        super.init()
    }
}
