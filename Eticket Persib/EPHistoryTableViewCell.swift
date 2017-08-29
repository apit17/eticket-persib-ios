//
//  EPHistoryTableViewCell.swift
//  Eticket Persib
//
//  Created by Apit on 6/10/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit

class EPHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var matchNameLabel: UILabel!
    @IBOutlet weak var ticketNameLabel: UILabel!
    @IBOutlet weak var ticketPriceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
