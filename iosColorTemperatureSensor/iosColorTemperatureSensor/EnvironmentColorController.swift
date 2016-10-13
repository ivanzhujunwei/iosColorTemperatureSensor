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

class EnvironmentColorController: UITableViewController {

    var pickedColors:[UIColor]!
    
    var environment:Environment!
    
    var setColor: setColorForEnvironmentDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if pickedColors == nil {
            pickedColors = [UIColor]()
        }
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
        if section == 0 {
            return 3
        }else if section == 1{
            return 1
        }else {
            return pickedColors.count
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("viewEnvironmentId", forIndexPath: indexPath)
            var displayText = "";
            switch indexPath.row {
            case 0:
                displayText = "Temperature: " + "\(environment.temperature)"
                break
            case 1:
                displayText = "Pressure: " + "\(environment.pressure)"
                break
            default:
                displayText = "Altimetre: " + "\(environment.altimeter)"
                break
            }
            cell.textLabel?.text = displayText
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("infoId", forIndexPath: indexPath)
            cell.textLabel?.text = "You can pick a color to mark the record"
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("colorInfoId", forIndexPath: indexPath)
            cell.backgroundColor = pickedColors[indexPath.row]
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get selected row index
        let indexPath = tableView.indexPathForSelectedRow!
        // Use delegate to set how many updates the user want to see
        setColor.setColorDelegate(pickedColors[indexPath.row])
        environment.color = pickedColors[indexPath.row]
        self.navigationController?.popViewControllerAnimated(true)
        
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
