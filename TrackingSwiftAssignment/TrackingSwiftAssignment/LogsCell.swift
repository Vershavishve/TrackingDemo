//
//  LogsCell.swift
//  TrackingSwiftAssignment
//
//  Created by Versha Vishavkarma on 04/05/21.
//  Copyright © 2021 Versha Vishve. All rights reserved.
//

import UIKit

class LogsCell: UITableViewCell {

    @IBOutlet weak var lblEnd: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblTimestamp: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
