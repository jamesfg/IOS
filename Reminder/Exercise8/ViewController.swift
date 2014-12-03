//
//  ViewController.swift
//  Exercise8
//
//  Created by ubicomp3 on 11/6/14.
//  Copyright (c) 2014 CPL. All rights reserved.
//

import UIKit
import Foundation
class ViewController: UIViewController {


    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "getBack")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "saveButton")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveButton() {
        let newReminder = Reminder(newTitle: self.titleTextField.text, newLocation: self.locationTextField.text, newDate: NSDate())
        var reminders: [Reminder] = []
        
        let dataArray : NSData? = NSUserDefaults.standardUserDefaults().objectForKey("reminders") as? NSData
        
        if dataArray != nil  {
            reminders = NSKeyedUnarchiver.unarchiveObjectWithData(dataArray!) as [Reminder]
        }
        reminders.append(newReminder)
        
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(reminders), forKey: "reminders")
        self.navigationController?.popViewControllerAnimated(true)
        
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Exercise8"
        localNotification.alertBody = self.titleTextField.text
        let randomNumber : NSTimeInterval = NSTimeInterval(arc4random_uniform(70)) + 30
        localNotification.fireDate = NSDate(timeIntervalSinceNow: randomNumber)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
    
    
    


}

