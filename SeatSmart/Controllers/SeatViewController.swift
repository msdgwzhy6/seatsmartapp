//
//  SeatViewController.swift
//  SeatSmart
//
//  Created by Cory Rodriguez on 2/23/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit
import WebKit

class SeatViewController: UIViewController, UITableViewDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var seatTableView: UITableView!
    @IBOutlet weak var seatingChartWebView: UIWebView!
    
    

    
    
    override func loadView() {
        super.loadView()
//        self.seatingChartWebView = WKWebView(frame: )
//        self.view = self.seatingChartWebView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSURL(string:"https://imap.ticketutils.net")
        var req = NSURLRequest(URL:url!)
        self.seatingChartWebView!.loadRequest(req)

    }
     
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //tapiping a seat should go to next view
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
