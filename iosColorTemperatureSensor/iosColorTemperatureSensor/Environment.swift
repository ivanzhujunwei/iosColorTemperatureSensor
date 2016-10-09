//
//  Environment.swift
//  iosColorTemperatureSensor
//
//  Created by zjw on 10/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import Foundation
class Environment {
    var temperature:NSNumber!
    var pressure:NSNumber!
    var altimeter:NSNumber!
    
//    var description: String{
//        let tempStr  = NSString(format:"%.2f",temperature) as String
//        let pressureStr  = NSString(format:"%.2f",pressure) as String
//        let altimeterStr  = NSString(format:"%.2f",altimeter) as String
//        return "Temp: " + tempStr  + ", Pressure: " + pressureStr + ", Altimeter: " + altimeterStr
//    }
    
    // Init function
        init(temperature:NSNumber, pressure:NSNumber, altimeter:NSNumber) {
            self.temperature = temperature
            self.pressure = pressure
            self.altimeter = altimeter
        }
    
    //        init(){}
    
}