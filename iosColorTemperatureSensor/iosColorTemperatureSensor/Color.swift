//
//  Color.swift
//  iosSensors
//
//  Created by zjw on 10/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import Foundation
import UIKit

class Color {
    
    var color = UIColor()
    var green:NSNumber!
    var blue:NSNumber!
    var red:NSNumber!
    
    // Init function
    init(green:NSNumber, blue:NSNumber, red:NSNumber) {
        self.green = green
        self.blue = red
        self.red = red
        self.color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
        
    }

}