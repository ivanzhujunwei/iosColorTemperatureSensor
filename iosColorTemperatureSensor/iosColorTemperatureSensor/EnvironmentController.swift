//
//  EnvironmentController.swift
//  iosColorTemperatureSensor
//
//  Created by zjw on 9/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class EnvironmentController: UITableViewController, SelectNUpdateDelegate, setColorForEnvironmentDelegate{
    
    //    var environment: Array<String>!
    var rowsOfEnvironment : Int!
    var environmentlist : [Environment]!
    // the picked colors by user
    var pickedColors: [UIColor]!
    // why I can't initialise the value inside the viewDidLoad() method ??????
    //    var tempEnvironment = [String]()
    var recordsInServer: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rowsOfEnvironment = 0
        environmentlist =  [Environment]()
        pickedColors = [UIColor]()
    }
    
    // Click the refresh button, reload the tableView data
    @IBAction func refreshTableView(sender: AnyObject) {
        self.tableView.reloadData()
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
        if section == 0{
            return 1;
        }else {
            return rowsOfEnvironment
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // reload data
        self.tableView.reloadData()
        // set the pickedColor the same as the color controller
        let colorTab = self.tabBarController?.viewControllers![1].childViewControllers[0] as! ColorController
        pickedColors = colorTab.pickedColors
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("updateEnvironmnetId", forIndexPath: indexPath)
            cell.textLabel?.text = "Please choose the number to show records"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("environmentId", forIndexPath: indexPath) as! EnvironmentTableViewCell
            if self.environmentlist.count > 0 && self.environmentlist.count > indexPath.row{
                cell.environment = self.environmentlist[indexPath.row]
                cell.textLabel?.text = cell.getText()
                cell.backgroundColor = self.environmentlist[indexPath.row].color
            }
            return cell
            
        }
    }
    
    func readSensorData(){
        let url = NSURL(string: "http://172.20.10.8:8088/")!
//        let url = NSURL(string: "http://192.168.1.18:8088/")!
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
                // If server only has 1 record, but the user request 20 records ？
                //                if anyObj.count < self.rowsOfEnvironment{
                //                    self.showAlertWithDismiss("Reminder", message: "Server only has " + "\(anyObj.count)" + " records right now, please request later.")
                //                }
                // If the number requested is bigger than the number of data server stored, should show the information
                if self.rowsOfEnvironment > anyObj.count{
                    self.showAlertWithDismiss("Reminder", message: "Sorry, server only has \(anyObj.count) records of data which will be shown.")
                    self.rowsOfEnvironment = anyObj.count
                }
                // remove the sensor data frist
                self.environmentlist.removeAll()
                // use anyObj here
                for i in 0 ..< self.rowsOfEnvironment {
                    let vv = anyObj[anyObj.count - 1 - i]
                    let temperature = vv["celsiusData"] as! NSNumber
                    let pressure = vv["pressureData"] as! NSNumber
                    let altimeter = vv["metreData"] as! NSNumber
                    let en = Environment ( temperature: temperature, pressure:pressure, altimeter:altimeter, color: UIColor.whiteColor() )
                    self.environmentlist.append(en)
                    self.tableView.reloadData()
                }
            } catch {
                print("json error: \(error)")
            }
        }
        result.resume()
        //        return cell
    }
    
    // MARK: - Delegate
    func selectNUpdate(nUpdate: Int) {
        rowsOfEnvironment = nUpdate
        readSensorData()
        self.tableView.reloadData()
    }
    
    func setColorDelegate(color: UIColor) {
//        
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectNUpdateSeg" {
            let nUpdateController = segue.destinationViewController as! NUpdatesEnController
            nUpdateController.selectNUpdate = self
        }else if segue.identifier == "enviroDetailSeg" {
            let showEnvironmnetView = segue.destinationViewController as! EnvironmentColorController
            // Get selected row index
            let indexPath = tableView.indexPathForSelectedRow
            showEnvironmnetView.environment = self.environmentlist![indexPath!.row]
            showEnvironmnetView.pickedColors = self.pickedColors
            showEnvironmnetView.setColor = self
        }
    }
    
    func showAlertWithDismiss(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertDismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertDismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
