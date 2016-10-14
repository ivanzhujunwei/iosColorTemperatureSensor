//
//  ColorPickTableViewCell.swift
//  iosSensors
//
//  Created by zjw on 10/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
// Custom cell: ColorPickTableView Cell
class ColorPickTableViewCell: UITableViewCell {
    
    // color picker click button
    @IBOutlet var colorPicker: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
