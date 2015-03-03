//
//  EventDetailsController.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/15/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit

var eventDates = [EventDate]()


class EventDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ticketTableView: UITableView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!

    var eventDate: EventDate!

    func loadInitialData() {
        
        let urlPath = "http://outsidervc.com/seatsmart/test_event_dates.json"
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            
            if((error) != nil) {
                println(error.localizedDescription)
            }

            var err: NSError?
            
            var jsonData: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err)!
            
            if(err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            //println(jsonData)
            
            self.eventDate = EventDate(fromString: jsonData["title"] as String)
            
            self.eventDate.eventId    = jsonData["eventId"] as String
            self.eventDate.type       = jsonData["type"] as String
            self.eventDate.priceRange = jsonData["priceRange"] as String
            self.eventDate.eventDates = jsonData["eventDates"] as NSArray

            self.eventTitleLabel.text = self.eventDate.title
        })
        
        task.resume()
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialData()


    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return eventDates.count }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("eventDatePrototypeCell", forIndexPath: indexPath) as UITableViewCell
        
        let eventDateRow: AnyObject = eventDates[indexPath.row]
        
        cell.textLabel?.text       = eventDates[indexPath.row].eventDates[indexPath.row]["location"] as? String
        cell.detailTextLabel?.text = eventDates[indexPath.row].eventDates[indexPath.row]["date"] as? String

        
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
