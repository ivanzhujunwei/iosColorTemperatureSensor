//
//  EnvironmentController.swift
//  iosColorTemperatureSensor
//
//  Created by zjw on 9/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

// This is the initial view of this project. It will display the caught information (altimeter,
// temperature and pressure) from the sensor and display them to the screen (the number of
// records to be displayed is defined in another view after clicked the first section of this view)
class EnvironmentController: UITableViewController, SelectNUpdateDelegate, setColorForEnvironmentDelegate{
    
    // rows of environment data will be displayed
    var rowsOfEnvironment : Int!
    // all displayed tableviewCells has one environment object which stored in the list
    var environmentlist : [Environment]!
    // the picked colors by user
    var pickedColors: [UIColor]!
    // why I can't initialise the value inside the viewDidLoad() method ??????
    var recordsInServer: Int!
    
//    @IBOutlet var loadingSensorId: UIActivityIndicatorView!
    // Call the first time this view is loaded.
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
    
    
    // set the number of sections for this table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    // set the number of rows for each section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1;
        }else {
                return self.rowsOfEnvironment
        }
    }
    
    // This function is called everytime the table is presented. It will refresh the table
    // and reload all the data. (each time this page is loaded, the caught colours from the
    // color sensor would be passed to this view and be further made use of.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // reload data
        self.tableView.reloadData()
        // set the pickedColor the same as the color controller
        let colorTab = self.tabBarController?.viewControllers![1].childViewControllers[0] as! ColorController
        pickedColors = colorTab.pickedColors
    }
    
    // Define the outlook of the cells for this view. The first section is supposed to show a
    // message, and if clicked, another table view will be presented. The second section is
    // supposed to show all the environment information caught by the sensor, and the number of
    // which is defined in another view
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
    
    // This function is used to use HTTP protocol to build connection to the environment sensor
    // The IP address and the port number is defined in the server. Data is transferred in JSON
    // format and the variable 'data' is used to store that JSON content and be further deployed
    // to receive the actual data. Eventually, the fetched data would be stored into the field
    // attribute of this view
    func readSensorData(){
//        let url = NSURL(string: "http://172.20.10.8:8088/")!
                let url = NSURL(string: "http://192.168.1.18:8088/")!
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let result = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // Async request, write code inside this handler once data has been processed
            do {
                // if no data is being received
                if data == nil {
                    self.showAlertWithDismiss("Error", message: "Server connection error!")
                    self.rowsOfEnvironment = 0
                    self.tableView.reloadData()
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
//                self.loadingSensorId.hidden = true
//                self.loadingSensorId.startAnimating()
//                self.tableView.hidden = false
            } catch {
                print("json error: \(error)")
            }
        }
        result.resume()
        //        return cell
    }
    
    // MARK: - Delegate
    // The delegate used to receive the configuration of how many rows to show defined in another view.
    func selectNUpdate(nUpdate: Int) {
//        loadingSensorId.hidden = false
//        loadingSensorId.startAnimating()
        environmentlist.removeAll()
        rowsOfEnvironment = nUpdate
        readSensorData()
        self.tableView.reloadData()
    }
    
    func setColorDelegate(color: UIColor) {
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before
    // navigation. Therefore, we use the prepareforsegue function here to process different
    // functions according to the different segue names. (sending the information contained
    // in the selected row)
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
    
    // Function to produce an alert for the user. It will be called when needed and the
    // message to be displayed will be given to this function
    func showAlertWithDismiss(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertDismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertDismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
