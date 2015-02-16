//
//  EventsViewController.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/15/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit

var selectedEventRow:Int = 0
var eventItems = [EventItem]()



class EventsViewController: UITableViewController {
    
    

    
    
    func loadInitialData() {
        var item1 = EventItem(fromString: "Event 1: Some Concert")
        item1.zip = "78209"
        item1.date = "2/15/2015"
        item1.basePrice = "25.00"
        
        var item2 = EventItem(fromString: "Event 2: Some Basketball Game")
        item2.zip = "78209"
        item2.date = "2/15/2015"
        item2.basePrice = "25.00"
        
        var item3 = EventItem(fromString: "Event 3: Some Broadway Show")
        item2.zip = "78209"
        item2.date = "2/15/2015"
        item2.basePrice = "25.00"
        
        eventItems.append(item1)
        eventItems.append(item2)
        eventItems.append(item3)
        
        println(eventItems)
        
        
//        let url = NSURL(string: "http://outsidervc.com/seatsmart/test_events_data.json")
//        let urlRequest = NSURLRequest(URL: url!)
//        
//        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
//            response, data, error in
//            
//            if error != nil {
//                println("there was an error")
//            }
//            
//            let eventItems = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
//            
//        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialData()
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventItemPrototypeCell", forIndexPath: indexPath) as UITableViewCell

        let eventItem = eventItems[indexPath.row]
        cell.textLabel?.text = eventItem.title

        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        selectedEventRow = indexPath.row
        
        return indexPath
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
