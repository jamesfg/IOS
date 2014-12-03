//
//  TableViewController.swift
//  Exercise8
//
//  Created by ubicomp3 on 11/6/14.
//  Copyright (c) 2014 CPL. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    var reminders: [Reminder] = []
    var currentReminder: Reminder?
    
    override func viewWillAppear(animated: Bool) {
        retrieveRemindersFromUserDefaults()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveRemindersFromUserDefaults()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func retrieveRemindersFromUserDefaults() {
        
        let dataArray : NSData? = NSUserDefaults.standardUserDefaults().objectForKey("reminders") as? NSData
        
        if dataArray != nil  {
            self.reminders = NSKeyedUnarchiver.unarchiveObjectWithData(dataArray!) as [Reminder]
        } else {
            self.reminders = []
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel?.text = self.reminders[indexPath.row].title
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueDetail") {
            let vc = segue.destinationViewController as DetailViewController
            vc.reminder = currentReminder
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       currentReminder = self.reminders[indexPath.row]
    }
    
    
    
}