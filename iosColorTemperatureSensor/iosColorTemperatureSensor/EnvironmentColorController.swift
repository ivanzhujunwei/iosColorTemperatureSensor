//
//  EnvironmentColorController.swift
//  iosSensors
//
//  Created by zjw on 12/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit
protocol setColorForEnvironmentDelegate {
    func setColorDelegate(color:UIColor)
}

// This view is used to diplay the information of the selected environment which is the in-house
// environment. Also, a weather API will be called to show the outside weather condition of
// Melbourne (comparisons would be made). Users can also connect the colors picked by the color
// sensor and the environment information picked by the environment sensor here
class EnvironmentColorController: UITableViewController {
    
    var pickedColors:[UIColor]!
    
    var environment:Environment!
    
    var setColor: setColorForEnvironmentDelegate!
    
    var currentTemp: String!
    var cityName:String!
    
    // This function is called the first time this view is loaded. So the weather API would be
    // used once the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        if pickedColors == nil {
            pickedColors = [UIColor]()
        }
        self.getWeatherData()
    }
    
    // Set current temperateure and location from weather API and deploy the JSON content to
    // store the content into the field variables.
    // reference: www.openweathermap.org/current
    func setCurrentTemperature(weatherData: NSData) {
        //        var jsonError: NSError?
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(weatherData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            if let name = json["name"] as? String {
                self.cityName = name
            }
            if let main = json["main"] as? NSDictionary {
                if let temp = main["temp"] as? Double {
                    self.currentTemp = String(format: "%.1f", (temp - 273.15))
                }
            }
        }
        catch {
            print("Error happens..")
        }
    }
    
    // get the information about the outside information of Melbourne from the weather API in
    // JSON format, and return the content to tthe setCurrentTemperature function to be further
    // deployed.
    func getWeatherData() {
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=Melbourne&APPID=a2d432705d96d247681bf14dcc613100")!
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let result = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in dispatch_async(dispatch_get_main_queue(), {self.setCurrentTemperature(data!)})
        }
        result.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // set the number of sections for this table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    // set the number of rows for each section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            return 1
        }else if section == 2{
            return 1
        }else
        {
            return pickedColors.count
        }
    }
    
    // Define the outlook of the cells for this view. (The first section is to display the
    // content of the in-house environment. The second section is to display the outside
    // environment of melbourne. The third section is to display a notice message, and the last
    // section is to display the available colours.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("viewEnvironmentId", forIndexPath: indexPath) as! WeatherTableViewCell
            cell.textLabel?.text = "\(environment.temperature)" + "°"
            cell.detailTextLabel!.text = environment.subInfo
            let currentTemp = Double(environment.temperature)
            if currentTemp > 20.0 {
                cell.weatherImage.image = UIImage(named:"sunshine")
            }else{
                cell.weatherImage.image = UIImage(named: "cloudy")
            }
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("currentId", forIndexPath: indexPath)
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2000 * Int64(NSEC_PER_MSEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                cell.textLabel!.text = "Outside temp:" + self.currentTemp + "°" + "  Location: " + self.cityName
            }
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("infoId", forIndexPath: indexPath)
            if pickedColors.count == 0{
                cell.textLabel?.text = "You haven't picked any colors."
            }else {
                cell.textLabel?.text = "Pick a color to mark the record."
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("colorInfoId", forIndexPath: indexPath)
            cell.backgroundColor = pickedColors[indexPath.row]
            return cell
        }
        
    }
    
    // Only the fouth section is able to be pressed
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 4{
            return true
        }
        else{
            return false
        }
    }
    
    // set the height of the first section to display a picture.
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 180
        }
        return UITableViewAutomaticDimension
    }
    
    // set the function to do when the rows of the last section is pressed (pass the information
    // of the selected row, returning to the previous view).
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 {
            // Get selected row index
            let indexPath = tableView.indexPathForSelectedRow!
            // Use delegate to set how many updates the user want to see
            setColor.setColorDelegate(pickedColors[indexPath.row])
            environment.color = pickedColors[indexPath.row]
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
