//
//  EPListNewsTableViewCell.swift
//  Eticket Persib
//
//  Created by Apit on 6/6/17.
//  Copyright © 2017 Apit. All rights reserved.
//

import UIKit

class EPListNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var personNews: UILabel!
    @IBOutlet weak var titleNews: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
