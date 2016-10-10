//
//  ColorController.swift
//  iosSensors
//
//  Created by zjw on 10/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class ColorController: UITableViewController, SelectNUpdateColorDelegate {
    
    var displayedColorCount: Int!
    var nUpdateColorCount: Int!
    var pickedColors: [UIColor]!
    
    @IBAction func pickColor(sender: UIBarButtonItem) {
        displayedColorCount = displayedColorCount + 1
        readColorSensor()
        self.tableView.reloadData()
    }
//    var colorPickerCell: ColorPickTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayedColorCount = 0
        nUpdateColorCount = 0
        pickedColors = [UIColor]()
        tableView.tableFooterView = UIView()
//        let cell = tableView.dequeueReusableCellWithIdentifier("colorPickerId", forIndexPath: indexPath) as! ColorPickTableViewCell
//        colorPickerCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ColorPickTableViewCell
        // Add listener to pick a color
//        colorPickerCell.colorPicker.addTarget(self, action: #selector(ColorController.addColor), forControlEvents: UIControlEvents.TouchUpInside)

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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("colorSelectId", forIndexPath: indexPath)
            cell.textLabel?.text = "Colors"
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
    
    func readColorSensor(){
        let url = NSURL(string: "http://192.168.1.18:8089/")!
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let result = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            // Async request, write code inside this handler once data has been processed
            do {
                // If there is only one group of data sent, which is not a NSArray, this would cause exception
                let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                // use anyObj here
//                let ff = anyObj.reverse()
//                for index in 0 ..< self.displayedColorCount {
                    let newObj = anyObj.reverse()
                    let vv = newObj[0]
                    let green = vv["green"] as! Double
                    let red = vv["red"] as! Double
                    let blue = vv["blue"] as! Double
                    let c = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                    print("展示多少条数据。。。"+"\(self.displayedColorCount)")
                    print("red.."+"\(red)")
                    print("green"+"\(green)")
                    print("blue"+"\(blue)")
                    self.pickedColors.append(c)
//                }
//                cell.textLabel?.text = "coloring.."
//                cell.textLabel?.backgroundColor = c
                self.tableView.reloadData()
            } catch {
                print("json error: \(error)")
            }
        }
        result.resume()
    
    }
    
    // MARK - Delegate
    func selectNUpdateColor(nUpdate: Int) {
        nUpdateColorCount = nUpdate
        if nUpdate > pickedColors.count {
            displayedColorCount = pickedColors.count
        }else{
            displayedColorCount = nUpdate
        }
        if nUpdate > pickedColors.count {
            showAlertWithDismiss("Reminder", message: "You only picked "+"\(pickedColors.count)"+" colors which would be showed")
        }
//        readColorSensor()
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
