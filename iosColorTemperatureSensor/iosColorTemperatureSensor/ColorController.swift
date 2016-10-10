//
//  ColorController.swift
//  iosSensors
//
//  Created by zjw on 10/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

class ColorController: UITableViewController, SelectNUpdateColorDelegate {
    
    var colorCount: Int!
    var colors: [UIColor]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorCount = 0
        colors = [UIColor]()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }else if section == 1{
            return 1
        }else {
            return colorCount
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("colorPickerId", forIndexPath: indexPath)
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("colorSelectId", forIndexPath: indexPath)
            cell.textLabel?.text = "Colors"
            return cell;
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("colorDisplayId", forIndexPath: indexPath)
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
//                    for index in 0 ..< self.colorCount {
                        let vv = anyObj[indexPath.row]
                        let green = vv["green"] as! Double
                        let red = vv["red"] as! Double
                        let blue = vv["blue"] as! Double
                        let c = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
//                        let c = UIColor(red: CGFloat(126/255), green: CGFloat(66.40783086353596/255), blue: CGFloat(74.72616676907762/255), alpha: 0.5)
                        self.colors.append(c)
                        cell.textLabel?.text = "color..."
                        cell.textLabel?.textColor = c
                        cell.textLabel?.backgroundColor = c
                } catch {
                    print("json error: \(error)")
                }
            }
            result.resume()
            cell.textLabel?.text = "Colors"
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0 {
            self.tableView.reloadData()
        }
    }
    
    // MARK - Delegate
    func selectNUpdateColor(nUpdate: Int) {
        colorCount = nUpdate
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
    
}
