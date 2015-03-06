//
//  EventTicket.swift
//  SeatSmart
//
//  Created by Cory Rodriguez on 3/6/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit

class EventTicket: NSObject {

    var title:      String
//    var type:       String
//    var priceRange: String
//    var eventId:    String
    var eventTickets: NSArray

    convenience override init() {
        self.init(fromString: "title")
    }

    init(fromString title: NSString) {
        self.title      = title
//        self.type       = ""
//        self.priceRange = "$0-$0"
//        self.eventId    = "0"
        self.eventTickets = []
        super.init()
    }

}
