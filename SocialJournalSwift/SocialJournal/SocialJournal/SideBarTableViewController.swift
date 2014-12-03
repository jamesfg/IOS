//
//  SideBarTableViewController.swift
//  SocialJournal
//
//  Created by Gabe on 11/16/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class SideBarTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verticallyCenterTableView()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    }

    func verticallyCenterTableView() {
        self.tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight|UIViewAutoresizing.FlexibleWidth
        var contentSize = self.tableView.contentSize
        var boundsSize = self.tableView.bounds.size
        var yOffset:CGFloat = 0.0
        if (contentSize.height < boundsSize.height){
            yOffset = floor((boundsSize.height - contentSize.height)/4)
        }
        // self.tableView.contentOffset = CGPointMake(0, yOffset);
        self.tableView.contentInset = UIEdgeInsets(top: yOffset, left: 0, bottom: 0, right: 0)
        
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // Return the number of sections.
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // Return the number of rows in the section.
//        return menuItems.count
//    }

    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("sideBarCell", forIndexPath: indexPath) as UITableViewCell
//        cell.imageView.image = menuItems[indexPath.row].1
//        cell.imageView.layer.cornerRadius = 10
//        cell.imageView.layer.borderWidth = 2
//        cell.imageView.layer.borderColor = UIColor.whiteColor().CGColor
//        cell.imageView.clipsToBounds = true
//        cell.textLabel.text = menuItems[indexPath.row].0
//        cell.backgroundColor = UIColor(red: 140, green: 168, blue: 41, alpha: 1)
//        
//
//        return cell
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
