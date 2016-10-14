//
//  Environment.swift
//  iosColorTemperatureSensor
//
//  Created by zjw on 10/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import Foundation
import UIKit
// Environment entity, including temperate, pressure, altimeter and displayed color
class Environment {
    var temperature:NSNumber!
    var pressure:NSNumber!
    var altimeter:NSNumber!
    var color:UIColor
    
    var description: String{
        let numberFormatter = NSNumberFormatter()
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        let tStr = numberFormatter.stringFromNumber(temperature)
        let pStr = numberFormatter.stringFromNumber(pressure)
        let aStr = numberFormatter.stringFromNumber(altimeter)
        return "T: " + tStr!  + ",  P: " + pStr! + ",  A: " + aStr!
    }
    
    var subInfo: String{
        let numberFormatter = NSNumberFormatter()
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        let pStr = numberFormatter.stringFromNumber(pressure)
        let aStr = numberFormatter.stringFromNumber(altimeter)
        return "Pressure: " + pStr! + ",  Altimeter: " + aStr!
    }
    // Init function
    init(temperature:NSNumber, pressure:NSNumber, altimeter:NSNumber, color: UIColor) {
            self.temperature = temperature
            self.pressure = pressure
            self.altimeter = altimeter
            self.color = color
        }
    
    //        init(){}
    
}
