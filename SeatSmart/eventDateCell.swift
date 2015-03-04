//
//  eventDateCell.swift
//  SeatSmart
//
//  Created by Cory Rodriguez on 3/4/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit

class eventDateCell: UITableViewCell {

    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //sets the labels inside the cell
    func setCell(dateLabelText: String, weekdayLabelText: String, timeLabelText: String, locationLabelText: String) {
        self.dateLabel.text     = dateLabelText
        self.timeLabel.text     = timeLabelText
        self.weekdayLabel.text  = weekdayLabelText
        self.locationLabel.text = locationLabelText
    }

}
