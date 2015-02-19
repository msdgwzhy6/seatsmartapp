//
//  EventDetailsController.swift
//  SeatSmart
//
//  Created by Huey Ly on 2/15/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit

class EventDetailsController: UIViewController {

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var eventZipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventTitleLabel.text = eventItems[selectedEventRow].title
        self.eventPriceLabel.text = "$" + eventItems[selectedEventRow].basePrice.stringValue
        self.eventDateLabel.text  = eventItems[selectedEventRow].date
        self.eventZipLabel.text   = eventItems[selectedEventRow].zip

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
