//
//  seatCell.swift
//  SeatSmart
//
//  Created by Cory Rodriguez on 3/4/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import UIKit

class seatCell: UITableViewCell {

    @IBOutlet weak var sectionRowLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
