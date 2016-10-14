//
//  ColorController.swift
//  iosSensors
//
//  Created by zjw on 10/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

// This is the main view for the color sensor. It will display the caught information (RGB
// information) from the sensor and display the actual color to the screen (the number of
// records to be displayed is defined in another view after clicked the first section of this view)
class ColorController: UITableViewController, SelectNUpdateColorDelegate {
    
    // count how many colors displayed
    var displayedColorCount: Int!
    
    // picked colors
    var pickedColors: [UIColor]!
    //
    //    var control: Int = 0
    
    // When the button is pressed, the data from the sensor would be retrieved.
    @IBAction func pickColor(sender: UIBarButtonItem) {
        displayedColorCount = displayedColorCount + 1
        readColorSensor()
        self.tableView.reloadData()
    }
    
    // This function is called the first time this view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        displayedColorCount = 0
        pickedColors = [UIColor]()
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // set the number of sections for this table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    // set the number of rows for each section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }else {
            return pickedColors.count > displayedColorCount ?
                // If the user has picked 20 colors, he wants to display 15 colors, then 15 colors will be displayed
                displayedColorCount :
                // If the user only pick 10 colors, but he wants to display 15 colors, only 10 colors will be displayed
                pickedColors.count
        }
    }
    
    // This function is called everytime the table is presented.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
    }
    
    // Define the outlook of the cells for this view. The first section is used to display a
    // prompt messaged and later ba pressed by the user. The second section is used to display
    // the captured colour from the color sensor.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("colorSelectId", forIndexPath: indexPath)
            cell.textLabel?.text = "Please choose the number to show colors."
            return cell;
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("colorDisplayId", forIndexPath: indexPath)
            print("indexPath.row -> "+"\(indexPath.row)")
            cell.backgroundColor = pickedColors[indexPath.row]
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    // This function is used to use HTTP protocol to build connection to the color sensor
    // The IP address and the port number is defined in the server. Data is transferred in JSON
    // format and the variable 'data' is used to store that JSON content and be further deployed
    // to receive the actual data. Eventually, the fetched data would be stored into the field
    // attribute of this view
    func readColorSensor(){
                let url = NSURL(string: "http://192.168.1.18:8089/")!
//        let url = NSURL(string: "http://172.20.10.8:8089/")!
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let result = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // Async request, write code inside this handler once data has been processed
            do {
                // if no data is being received
                if data == nil {
                    self.showAlertWithDismiss("Error", message: "Server connection error!")
                    return
                }
                // If there is only one group of data sent, which is not a NSArray, this would cause exception
                let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                // use anyObj here
                //let newObj = anyObj.reverse()
                let sensorData = anyObj[anyObj.count-1]
                if sensorData.count == 1{
                    //                    let errorResponse = sensorData["err"]
                    self.showAlertWithDismiss("Error", message: "Sorry, failed to read from device.")
                    //                    self.showAlertWithDismiss("Error", message: errorResponse)
                    return
                }
                let green = sensorData["green"] as! Double
                let red = sensorData["red"] as! Double
                let blue = sensorData["blue"] as! Double
                let c = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                //                    print("展示多少条数据。。。"+"\(self.displayedColorCount)")
                //                    print("red.."+"\(red)")
                //                    print("green"+"\(green)")
                //                    print("blue"+"\(blue)")
                self.pickedColors.append(c)
                self.tableView.reloadData()
            } catch {
                print("json error: \(error)")
            }
        }
        result.resume()
        
    }
    
    ///////////////////////
    //    func readColorSensorFirst(){
    //        let url = NSURL(string: "http://172.20.10.8:8089/")!
    //        let urlRequest = NSURLRequest(URL: url)
    //        let session = NSURLSession.sharedSession()
    //        let result = session.dataTaskWithRequest(urlRequest) {
    //            (data, response, error) in
    //            // Async request, write code inside this handler once data has been processed
    //            do {
    // If there is only one group of data sent, which is not a NSArray, this would cause exception
    //                let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
    // use anyObj here
    //let newObj = anyObj.reverse()
    //                let vv = anyObj[anyObj.count-1]
    //                let green = vv["green"] as! Double
    //                let red = vv["red"] as! Double
    //                let blue = vv["blue"] as! Double
    //                self.tableView.reloadData()
    //            } catch {
    //                print("json error: \(error)")
    //            }
    //        }
    //        result.resume()
    //
    //    }
    
    
    // function used to prevent the user from selecting to show more colors than the actual
    // stored colour number.
    func selectNUpdateColor(nUpdate: Int) {
        if nUpdate > pickedColors.count {
            displayedColorCount = pickedColors.count
        }else{
            displayedColorCount = nUpdate
        }
        if nUpdate > pickedColors.count {
            var responseMsg = ""
            if pickedColors.count == 0 {
                responseMsg = "Hi, you haven't picked any color yet, please pick one first."
            }else {
                responseMsg = "You only picked "+"\(pickedColors.count)"+" colors which will be shown."
            }
            showAlertWithDismiss("Reminder", message: responseMsg)
        }
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // function used to provide the delete function to delete the selected color
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if editingStyle == .Delete {
                // Delete the color from the color Array
                pickedColors.removeAtIndex(indexPath.row)
                // Delete the row from the data source
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.tableView.reloadData()
            }
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectColorCountSeg" {
            let colorView = segue.destinationViewController as! NUpdateColorController
            colorView.selectNUpdate = self
        }
    }
    
    func showAlertWithDismiss(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertDismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        // pop here
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
        alertController.addAction(alertDismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
