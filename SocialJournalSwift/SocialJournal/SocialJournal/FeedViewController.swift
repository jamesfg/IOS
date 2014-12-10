//
//  FeedViewController.swift
//  SocialJournal
//
//  Created by Muhammad Naviwala on 11/17/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var selectFeedType: UISegmentedControl!
    @IBOutlet weak var leftImage: UIImageView!
    var button: HamburgerButton! = nil
    var allEntries = []
    var heartbeat = [(Double,PFObject)]()
    var allUsers:[PFUser?] = []
    var allUsersProfileImage:[UIImage?] = []
    var allLikes:[Int] = []
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var refreshControl:UIRefreshControl!
    
    var currentEntry = PFObject(className: "Entry")
//    var something:PFObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTheHamburgerIcon()
        self.spinner.center = self.view.center
        self.spinner.startAnimating()
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.attributedTitle = NSAttributedString(string:"Pull to refresh", attributes:
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 18.0)!])
        refreshControl.addTarget(self, action: "fetchData", forControlEvents: UIControlEvents.ValueChanged)
        feedTableView.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchData()
        feedTableView.reloadData()
        feedTableView.reloadInputViews()
    }
    
    func setupTheHamburgerIcon() {
        self.button = HamburgerButton(frame: CGRectMake(20, 20, 60, 60))
        self.button.addTarget(self, action: "toggle:", forControlEvents:.TouchUpInside)
        self.button.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: self.button)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    func fetchData() {
        var query = ParseQueries.queryForEntries(PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                 self.allEntries = objects
                
                self.feedTableView.reloadData()
                for entry:PFObject in self.allEntries as [PFObject] {
                    //get user
                    var user = entry["user"] as PFUser
                    user.fetchIfNeeded()
                    self.allUsers.append(user)
                    entry["theUserName"] = user.username
                    //get profile image
                    var userImageFile:PFFile? = user["profileImage"] as? PFFile
                    var imageData = userImageFile?.getData()
                    if imageData != nil {
                        entry["theUserImage"] = imageData
                        self.allUsersProfileImage.append(UIImage(data: imageData!)!)
                    }else {
                        entry["theUserImage"] = nil
                        self.allUsersProfileImage.append(nil)
                    }
                    //get like bool
                    var query = PFQuery(className: "Activity")
                    query.whereKey("entry", equalTo: entry)
                    query.whereKey("type", equalTo: "like")
                    var likes = query.findObjects()
                    entry["likeCount"] = likes.count
                    self.assignHeartBeatTEST(entry)
                    self.allLikes.append(likes.count)
                }
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
            
            if((self.refreshControl) != nil){
                self.refreshControl.endRefreshing()
            }
            
            if(self.spinner.isAnimating()){
                self.spinner.stopAnimating()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggle(sender: AnyObject!) {
        self.button.showsMenu = !self.button.showsMenu
    }
    
    
    
    // UITableViewDataSource methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.feedTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.allEntries.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:feedCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("feedCell") as feedCellTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        if (self.allEntries != []){
            var entry:PFObject = self.allEntries[indexPath.section] as PFObject
            
//            println(entry)
            
//            cell.username.text = self.allUsers[indexPath.section]!.username
            cell.username.text = entry["theUserName"] as? String
            
//            if self.allUsersProfileImage[indexPath.section] != nil {
//                cell.userProfilePicture.image = self.allUsersProfileImage[indexPath.section]
//            }
            
            if (entry["theUserImage"] != nil){
                println("user image ok")
                cell.userProfilePicture.image = UIImage(data: entry["theUserImage"] as NSData)
            }
            
            var query = PFQuery(className: "Activity")
            query.whereKey("entry", equalTo: entry)
            query.whereKey("fromUser", equalTo: PFUser.currentUser())
            query.whereKey("type", equalTo: "like")
            var likes = query.findObjects()
            
            if likes.count > 0 {
                cell.hearted.tintColor = UIColor.redColor()
                cell.hearted.image = UIImage(named: "HeartRed")
            }
            else{
                cell.hearted.tintColor = UIColor.whiteColor()
                cell.hearted.image = UIImage(named: "HeartWhite")
            }
            
            var entryTitle:String = entry["title"] as String!
            var entryText:String = entry["content"] as String!
            
//            cell.heartCount.text = String(self.allLikes[indexPath.section])
            cell.heartCount.text = entry["likeCount"].stringValue
            
            cell.postTitle.text = entryTitle
            cell.postBody.text = entryText
            assignDate(entry.createdAt, cell: cell)
        }
        return cell
    }
    
    @IBAction func feedSelected(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            var descriptor = NSSortDescriptor(key: "createdAt.timeIntervalSince1970", ascending: false)
            var sortDescriptors = [descriptor]
            var sortedArray = self.allEntries.sortedArrayUsingDescriptors(sortDescriptors)
            self.allEntries = sortedArray
            self.feedTableView.reloadData()
            self.feedTableView.reloadInputViews()

        case 1:
            var descriptor = NSSortDescriptor(key: "heartBeat", ascending: false)
            var sortDescriptors = [descriptor]
            var sortedArray = self.allEntries.sortedArrayUsingDescriptors(sortDescriptors)
            println(sortedArray)
            self.allEntries = sortedArray
            self.feedTableView.reloadData()
            self.feedTableView.reloadInputViews()
            
        default:
            break;
        }
    }
    func assignDate(date:NSDate, cell:feedCellTableViewCell) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        cell.dateWeekday.text = dateFormatter.stringFromDate(date)
        
        dateFormatter.setLocalizedDateFormatFromTemplate("dd")
        cell.dateDay.text = dateFormatter.stringFromDate(date)
        
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
        cell.dateMonth.text = dateFormatter.stringFromDate(date)
        
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYY")
        cell.dateYear.text = dateFormatter.stringFromDate(date)
    }
    
    
    func assignHeartBeatTEST(entry: PFObject){
        var heartInt = entry["likeCount"] as Double
        var order = log10((max(heartInt, 1)))
        var seconds = entry.createdAt.timeIntervalSince1970 - 1134028003
        var format = (Double(order) + (seconds / 45000))
        var hotness = round(format * 100) / 100.0
        entry["heartBeat"] = hotness
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
        
        if segue.identifier == "feedToEntry"{
            var selectedRowIndexPath: NSIndexPath = self.feedTableView.indexPathForSelectedRow()!
            var selectedSection: NSInteger = selectedRowIndexPath.section
            
            let vc = segue.destinationViewController as EntryViewController
            vc.entry = self.allEntries[selectedSection] as PFObject
        }
    }

    
}

