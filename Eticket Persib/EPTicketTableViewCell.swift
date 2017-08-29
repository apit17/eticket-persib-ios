//
//  EPTicketTableViewCell.swift
//  Eticket Persib
//
//  Created by Apit on 6/8/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit

class EPTicketTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var seatCategoryLabel: UILabel!
    @IBOutlet weak var dateAvailable: UILabel!
    @IBOutlet weak var stockStatus: UILabel!
    @IBOutlet weak var readyOnLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
