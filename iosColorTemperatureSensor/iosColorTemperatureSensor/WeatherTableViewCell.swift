//
//  WeatherTableViewCell.swift
//  iosSensors
//
//  Created by zjw on 13/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
// Custom cell: WeatherTableView Cell
class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var weatherImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
