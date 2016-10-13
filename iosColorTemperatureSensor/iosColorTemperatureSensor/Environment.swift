//
//  Environment.swift
//  iosColorTemperatureSensor
//
//  Created by zjw on 10/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import Foundation
import UIKit
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
//        let tempStr  = NSString(format:"%.2f",temperature) as String
//        let pressureStr  = NSString(format:"%.2f",pressure) as String
//        let altimeterStr  = NSString(format:"%.2f",altimeter) as String
//        return "Temp: " + tempStr  + ", Pressure: " + pressureStr + ", Altimeter: " + altimeterStr
//        return "Temp: " + tStr!  + ", Pressure: " + pStr! + ", Altimeter: " + aStr!
        return "T: " + tStr!  + ",  P: " + pStr! + ",  A: " + aStr!
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
