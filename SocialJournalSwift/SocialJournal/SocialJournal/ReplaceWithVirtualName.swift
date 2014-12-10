//
//  ReplaceWithVirtualName.swift
//  SocialJournal
//
//  Created by Xiaolu Zhang on 12/2/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class ReplaceWithVirtualName: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var virtualName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var virtualNameDictionary = Dictionary<String,String>()
    var keyArray = Array <String>()
    var valueArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVirtualNamesFromNSUserDefaults()

        var addButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Bordered, target: self, action: "addOrDeleteRows")
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    func addOrDeleteRows(){
        if (self.editing){
            super.setEditing(false, animated: false)
            tableView.setEditing(true, animated: true)
            tableView.reloadData()
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            self.navigationItem.rightBarButtonItem?.style = UIBarButtonItemStyle.Plain
        }else{
            super.setEditing(true, animated: true)
            tableView.setEditing(true, animated: true)
            tableView.reloadData()
            self.navigationItem.rightBarButtonItem?.title = "Done"
            self.navigationItem.rightBarButtonItem?.style = UIBarButtonItemStyle.Done
        }
        
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (self.editing == false){
            return UITableViewCellEditingStyle.None
        }
        
        if (self.editing && indexPath.row == countElements(virtualNameDictionary)){
            return UITableViewCellEditingStyle.Insert
        }else{
            return UITableViewCellEditingStyle.Delete
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            var cell = self.tableView.cellForRowAtIndexPath(indexPath) as VirtualNameTableViewCell
            virtualNameDictionary.removeValueForKey(cell.keyword.text!)
            
            //reset both arrays to avoid extra elements
            self.keyArray.removeAll(keepCapacity: false)
            self.valueArray.removeAll(keepCapacity: false)
            
            //refill both arrays
            for (key, value) in virtualNameDictionary{
                self.keyArray.append(key)
                self.valueArray.append(value)
            }
            
            //println(self.virtualNameDictionary)
            saveToNSUserDefaults()
            self.tableView.reloadData()
            
        }
        else if (editingStyle == UITableViewCellEditingStyle.Insert){
            var cell = self.tableView.cellForRowAtIndexPath(indexPath) as AddNewVirtualNameTableViewCell
            
            keyword.text = cell.keywordTextbox.text
            virtualName.text = cell.virtualNameTextbox.text
            actuallySaveChange()
            
            cell.keywordTextbox.text = ""
            cell.virtualNameTextbox.text = ""
        }
        
    }
    
    func actuallySaveChange(){
        //check if its an empty virtual name
        if keyword.text != "" && virtualName.text != ""{
            self.virtualNameDictionary[keyword.text] = virtualName.text
        }else{
            let alertController = UIAlertController(title: "Sorry", message:
                "Virtual names and their replacements cannot be empty.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        //reset both arrays to avoid extra elements
        self.keyArray.removeAll(keepCapacity: false)
        self.valueArray.removeAll(keepCapacity: false)
        
        //refill both arrays
        for (key, value) in virtualNameDictionary{
            self.keyArray.append(key)
            self.valueArray.append(value)
        }
        
        //reset text fields
        self.keyword.text = ""
        self.virtualName.text = ""
        
        //println(self.virtualNameDictionary)
        saveToNSUserDefaults()
        self.tableView?.reloadData()
    }
    
    @IBAction func saveChange(sender: AnyObject) {
        actuallySaveChange()
    }
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
        self.virtualNameDictionary.removeAll(keepCapacity: false)
        self.tableView?.reloadData()
    }
    
    func getVirtualNamesFromNSUserDefaults(){
        var userDefaults = NSUserDefaults.standardUserDefaults()
        if let virtualNames = userDefaults.objectForKey("virtualNamesDictionary") as? Dictionary<String,String>{
            self.virtualNameDictionary = virtualNames
            //refill both arrays
            for (key, value) in virtualNameDictionary{
                self.keyArray.append(key)
                self.valueArray.append(value)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveToNSUserDefaults(){
        var userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(self.virtualNameDictionary, forKey: "virtualNamesDictionary")
        userDefaults.synchronize()
    }
    
    // UITableViewDataSource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.editing){
            return countElements(virtualNameDictionary) + 1
        }else{
            return countElements(virtualNameDictionary)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView?.dequeueReusableCellWithIdentifier("displayCell") as VirtualNameTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        if(indexPath.row == countElements(virtualNameDictionary) && self.editing){var cell = self.tableView?.dequeueReusableCellWithIdentifier("addNewRowCell") as AddNewVirtualNameTableViewCell
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }
        
        cell.keyword.text = self.keyArray[indexPath.row]
        cell.virtualName.text = self.valueArray[indexPath.row]
        return cell
    }
}