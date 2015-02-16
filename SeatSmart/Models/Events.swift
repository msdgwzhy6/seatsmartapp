//
//  Events.swift
//  SeatSmart
//
//  Created by Cory Rodriguez on 2/16/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import Foundation
import CoreData

class Events: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var zip: String
    @NSManaged var date: NSDate
    @NSManaged var basePrice: NSNumber
    @NSManaged var latitude: String
    @NSManaged var longitude: String

}
