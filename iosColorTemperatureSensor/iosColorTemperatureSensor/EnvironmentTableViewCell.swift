//
//  EnvironmentTableViewCell.swift
//  iosColorTemperatureSensor
//
//  Created by zjw on 10/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class EnvironmentTableViewCell: UITableViewCell {
    
    var environment: Environment!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func getText() -> String{
        return environment.description;
    }

}
