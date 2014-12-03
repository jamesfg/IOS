//
//  NotificationsViewController.swift
//  SocialJournal
//
//  Created by Muhammad Naviwala on 11/17/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var button: HamburgerButton! = nil
    var notifications = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHamburgerButton()
        getNotifications()
   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggle(sender: AnyObject!) {
        self.button.showsMenu = !self.button.showsMenu
    }
    
    
    func configureHamburgerButton() {
        self.button = HamburgerButton(frame: CGRectMake(20, 20, 60, 60))
        self.button.addTarget(self, action: "toggle:", forControlEvents:.TouchUpInside)
        self.button.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        // self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: self.button)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    func getNotifications() {
        var query:PFQuery = ParseQueries.queryForNotifications(PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.notifications = objects as [PFObject]
                self.tableView.reloadData()
                for object in self.notifications {
                    println(object)
                }
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    
    // UITableViewDataSource methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.notifications.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:NotificationTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("notificationCell") as NotificationTableViewCell
        if self.notifications != [] {
            var activity:PFObject = self.notifications[indexPath.row] as PFObject
            var fromUser:PFUser = activity["fromUser"].fetchIfNeeded() as PFUser
            switch activity["type"] as String! {
            case "follow":
                cell.notifcationLabel.text = "\(fromUser.username) is now Following you!"
            case "like":
                cell.notifcationLabel.text = "\(fromUser.username) liked your post!"
            case "comment":
                cell.notifcationLabel.text = "\(fromUser.username) commented on your post!"
            default:
                cell.notifcationLabel.text = "Error: No Comment, Like or Follow detected."
            }
        }
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    // UITableViewDelegate methods
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        var headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 1))
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 30.0
    }
    
    func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 150
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
//        if segue.identifier == "feedToEntry"{
//            var selectedRowIndexPath: NSIndexPath = self.feedTableView.indexPathForSelectedRow()!
//            var selectedSection: NSInteger = selectedRowIndexPath.section
//            
//            let vc = segue.destinationViewController as EntryViewController
//            vc.entry = self.allEntries[selectedSection] as PFObject
//        }
    }
    


}

