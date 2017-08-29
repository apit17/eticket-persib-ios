//
//  EPScheduleTableViewCell.swift
//  Eticket Persib
//
//  Created by Apit on 6/8/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit

class EPScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var teamAwayLabel: UILabel!
    @IBOutlet weak var teamAwayImageView: UIImageView!
    @IBOutlet weak var teamHomeLabel: UILabel!
    @IBOutlet weak var teamHomeImageView: UIImageView!
    @IBOutlet weak var timeMatchLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
