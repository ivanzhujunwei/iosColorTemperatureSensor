//
// NUpdatesEnController.swift
//  iosSensors
//
//  Created by zjw on 10/10/16.
//  Copyright © 2016 FIT5140. All rights reserved.
//

import UIKit

// Delegate: select how many records that need to be udpated
protocol SelectNUpdateDelegate {
    func selectNUpdate(nUpdate: Int)
}

// This view is called by clicking the first row of the EnvironmentController view to select how
// many records to be shown
class NUpdatesEnController: UITableViewController {
    
    var nUpdates: [Int]!
    var selectNUpdate: SelectNUpdateDelegate?
    
    // This function is called the first time this view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        nUpdates = [1,2,3,4,5,6,7,8,9,10,15]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // set the number of sections for this table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // set the number of rows for each section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nUpdates.count
    }
    
    // Define the outlook of the cells for this view. There is only one section in this view,
    // enabling the user to select to number of record to show.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nupdatesId", forIndexPath: indexPath)
        cell.textLabel?.text = "\(nUpdates[indexPath.row])"
        return cell
    }
    
    // This function is called when a certain row is clicked. It will store the information of
    // the selected row and return the view to the previous one.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get selected row index
        let indexPath = tableView.indexPathForSelectedRow!
        // Use delegate to set how many updates the user want to see
        selectNUpdate?.selectNUpdate(nUpdates[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
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
