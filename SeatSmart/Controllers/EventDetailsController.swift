//
//  EventDetailsController.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/15/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit

//var eventDates = [EventDate]()

class EventDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ticketTableView: UITableView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!

    var event: EventDate!
    let seatsmartApi = SeatSmartApi()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.seatsmartApi.getEvents("test_event_dates.json", self.handleGetEvents)
    }
    
    func handleGetEvents(responseData : AnyObject) {
        
        var jsonData : AnyObject = responseData
        
        self.event = EventDate(fromString: jsonData["title"] as String)
        
        self.event.eventId    = jsonData["eventId"] as String
        self.event.type       = jsonData["type"] as String
        self.event.priceRange = jsonData["priceRange"] as String
        self.event.eventDates = jsonData["eventDates"] as NSArray
        
        self.eventTitleLabel.text = self.event.title
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.ticketTableView.reloadData()
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.event == nil) {
            return 0
        } else {
            return self.event.eventDates.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: eventDateCell = tableView.dequeueReusableCellWithIdentifier("eventDatePrototypeCell", forIndexPath: indexPath) as eventDateCell

        var eventDatesArray: AnyObject = self.event.eventDates[indexPath.row]

        cell.setCell(eventDatesArray["eventDt"] as String,
            weekdayLabelText: eventDatesArray["weekday"] as String,
            timeLabelText: eventDatesArray["time"] as String,
            locationLabelText: eventDatesArray["location"] as String)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //what happens when a table cell is tapped
        //go to next view with quantity confirmation and email address box/i have an account
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
