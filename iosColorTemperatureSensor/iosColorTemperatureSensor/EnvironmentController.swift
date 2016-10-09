//
//  EnvironmentController.swift
//  iosColorTemperatureSensor
//
//  Created by zjw on 9/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class EnvironmentController: UITableViewController {

//    var environment: Array<String>!
    var enlist =  [Environment]()
    // why I can't initialise the value inside the viewDidLoad() method ??????
//    var tempEnvironment = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let url = NSURL(string: "http://192.168.1.18:8088/")!
        //        [{"pressureData":101.6619,"celsiusData":23,"metreData":22.8},{"pressureData":101.6619,"celsiusData":23,"metreData":22.8}]
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let result = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // Async request, write code inside this handler once data has been processed
            do {
                // If there is only one group of data sent, which is not a NSArray, this would cause exception
                let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                // use anyObj here
                for vv in anyObj {
                    let temperature = vv["celsiusData"] as! NSNumber
                    let pressure = vv["pressureData"] as! NSNumber
                    let altimeter = vv["metreData"] as! NSNumber
                    let en = Environment ( temperature: temperature, pressure:pressure, altimeter:altimeter)
                    self.enlist.append(en)
                }
            } catch {
                print("json error: \(error)")
            }
        }
        result.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1;
        }else {
            return enlist.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("updateEnvironmnetId", forIndexPath: indexPath)
            cell.textLabel?.text = "Current value"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("environmentId", forIndexPath: indexPath)
            
            return cell

        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
