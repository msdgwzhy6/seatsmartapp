//
//  SeatViewController.swift
//  SeatSmart
//
//  Created by Cory Rodriguez on 2/23/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit
import WebKit

class SeatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, WKScriptMessageHandler {

    var ticket: EventTicket!
    let seatSmartApi = SeatSmartApi()

    @IBOutlet var containerView : UIView! = nil //may not be needed

    @IBOutlet weak var seatTableView: UITableView!
    @IBOutlet weak var seatingChartWebView: UIWebView!

    override func loadView() {
        super.loadView()    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.seatSmartApi.getEvents("test_event_tickets.json", self.handleGetEvents)
        let path = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        var requestURL = NSURL(string:path!);
        var req = NSURLRequest(URL:requestURL!);

        self.seatingChartWebView.loadRequest(req)

    }

    func handleGetEvents(responseData : AnyObject) {
        var jsonData : AnyObject = responseData

        self.ticket = EventTicket(fromString: jsonData["title"] as String)

        self.ticket.eventTickets = jsonData["eventTickets"] as NSArray
        println(self.ticket)

        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.seatTableView.reloadData()
        })
    }

    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {

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
        //tapping a seat should highight the seat on the seating chart
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
