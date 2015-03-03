//
//  EventsViewController.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/15/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit
import Foundation

var selectedEventRow:Int = 0
var eventItems = [EventItem]()

class EventsViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var eventsTableView: UITableView!
    @IBOutlet weak var searchTextField: UISearchBar!
    
    var searchActive : Bool = false
    var searchIsTyping : Bool = false
    
    func loadInitialData() {
        
        let urlPath = "http://outsidervc.com/seatsmart/seatsmart-test-data.json"
        self.loadTableDataFromUrl(urlPath)
        self.eventsTableView.rowHeight = 130
        self.eventsTableView.backgroundView = UIImageView(image: UIImage(named: "bg-login"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialData()
        self.searchTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTableDataFromUrl(urlPath: String) {
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url, completionHandler: {
            data, response, error -> Void in
            
            if((error) != nil) {
                println(error.localizedDescription)
            }
            
            var err: NSError?
            
            var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSArray
            
            if(err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            eventItems.removeAll();
            for item: AnyObject in jsonData {
                
                var eventItem       = EventItem(fromString: item["title"] as String)
                
                eventItem.basePrice = item["basePrice"] as NSNumber
                eventItem.date      = item["date"] as String
                eventItem.latidude  = item["latitude"] as String
                eventItem.longitude = item["longitude"] as String
                eventItem.zip       = item["zip"] as String
                
                eventItems.append(eventItem)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.eventsTableView.reloadData()
            })
        })
        
        task.resume()
    }
    
    // MARK: - Search bar functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        Util.delay(0.5) {
            var urlPath = "http://outsidervc.com/seatsmart/seatsmart-test-searchresults.json"
            if (searchText == "") {
                urlPath = "http://outsidervc.com/seatsmart/seatsmart-test-data.json"
            }
            println("Search for " + searchText)
            self.loadTableDataFromUrl(urlPath)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventItemPrototypeCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = UIImageView(image: UIImage(named: "event\(indexPath.row + 1)"))
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        let eventItem = eventItems[indexPath.row]
        cell.textLabel?.text = eventItem.title
        cell.detailTextLabel?.text = eventItem.date
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        selectedEventRow = indexPath.row
        
        return indexPath
    }
}
