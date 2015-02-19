//
//  SeatSmart.swift
//  SeatSmart
//
//  Created by Cory Rodriguez on 2/16/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//
//made from the SeatSmart.xcdatamodeId

import Foundation
import CoreData

class Event: NSManagedObject {

    @NSManaged var basePrice: NSDecimalNumber
    @NSManaged var date: NSDate
    @NSManaged var latitude: String
    @NSManaged var longitude: String
    @NSManaged var title: String
    @NSManaged var zip: String

}
