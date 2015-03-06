//
//  SeatViewController.swift
//  SeatSmart
//
//  Created by Cory Rodriguez on 2/23/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit
import WebKit

class SeatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

    var ticket: EventTicket!
    
    @IBOutlet weak var seatTableView: UITableView!
    @IBOutlet weak var seatingChartWebView: UIWebView!

    override func loadView() {
        super.loadView()
//        self.seatingChartWebView = WKWebView(frame: )
//        self.view = self.seatingChartWebView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialData()
        
        var url = NSURL(string:"http://outsidervc.com/seatsmart/sample-theatre.png")
        var req = NSURLRequest(URL:url!)
        self.seatingChartWebView!.loadRequest(req)

    }

    func loadInitialData() {

        let urlPath = "http://outsidervc.com/seatsmart/test_event_tickets.json"
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
println(jsonData["title"])
            self.ticket = EventTicket(fromString: jsonData["title"] as String)

            self.ticket.eventTickets = jsonData["eventTickets"] as NSArray
            println(self.ticket)

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.seatTableView.reloadData()
            })
        })


        task.resume()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //for now
        //return eventTickets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: seatCell = tableView.dequeueReusableCellWithIdentifier("seatPrototypeCell", forIndexPath: indexPath) as seatCell

                cell.sectionRowLabel.text = self.ticket.eventTickets[indexPath.row]["seatNumber"] as? String
                cell.quantityLabel.text   = self.ticket.eventTickets[indexPath.row]["numAvailable"] as? String
                cell.priceLabel.text      = self.ticket.eventTickets[indexPath.row]["price"] as? String

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //tapping a seat should go to next view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
