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

class EventsViewController: UITableViewController, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet var eventsTableView: UITableView!
    @IBOutlet weak var searchTextField: UISearchBar!
    
    var searchActive : Bool = false
    var searchIsTyping : Bool = false
    var userSearched : Bool = false
    let seatsmartApi = SeatSmartApi()
    
    func loadInitialData() {
        
        self.seatsmartApi.getEvents("", self.handleGetEvents)
        
        self.eventsTableView.rowHeight = 130
        self.eventsTableView.backgroundView = UIImageView(image: UIImage(named: "bg-login"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialData()
        self.searchTextField.delegate = self
        self.eventsTableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleGetEvents(responseData : AnyObject) {

        var jsonData : NSArray = responseData as NSArray
        
        eventItems.removeAll()
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
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
        self.searchTextField.resignFirstResponder()
    }
    
    // MARK: - Search bar functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        println("searched ended editing")
        self.dismissKeyboard()
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        println("searched button cancel clicked")
        searchActive = false
        self.dismissKeyboard()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        println("searched button clicked")
        self.dismissKeyboard()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.userSearched = true
        var filter = "seatsmart-test-searchresults.json"
        if (searchText == "") {
            self.userSearched = false
            filter = "seatsmart-test-data.json"
        }
        println("Search for " + searchText)
        self.seatsmartApi.getEvents(filter, self.handleGetEvents)
    }
    
    // MARK - tableview funcs
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventItemPrototypeCell", forIndexPath: indexPath) as UITableViewCell
        
        var imageName = "event"
        if (self.userSearched) {
            imageName = "search-result"
        }
        
        var imageIndex = indexPath.row + 1
        if (imageIndex > 8) {
            imageIndex -= 8
        }
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = UIImageView(image: UIImage(named: "\(imageName)\(imageIndex)"))
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        if (eventItems.count >= indexPath.row + 1) {
            let eventItem = eventItems[indexPath.row]
            cell.textLabel?.text = eventItem.title
            cell.detailTextLabel?.text = eventItem.date
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        selectedEventRow = indexPath.row
        
        return indexPath
    }
}
