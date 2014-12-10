//
//  EntryViewController.swift
//  SocialJournal
//
//  Created by James Garcia on 11/19/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var button: HamburgerButton! = nil
    
    @IBOutlet weak var showCommentsVisualView: UIVisualEffectView!
    var showCommentsToggle = true
    @IBOutlet weak var commentsTable: UITableView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var heartLike: UIButton!
    @IBOutlet weak var heartCount: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postBody: UITextView!
    @IBOutlet weak var dateWeekday: UILabel!
    @IBOutlet weak var dateDay: UILabel!
    @IBOutlet weak var dateMonth: UILabel!
    @IBOutlet weak var dateYear: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    var entry = PFObject(className: "Entry")
    
    var comments = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.entry["user"].fetchIfNeeded()
        var user:PFUser = self.entry["user"] as PFUser
        self.username.text = user.username
        
        
        if(self.navigationItem.hidesBackButton){
            self.setupTheHamburgerIcon()
            self.navigationItem.setHidesBackButton(false, animated: true)
        }
        
        if(self.username.text == PFUser.currentUser().username){
            self.deleteButton.enabled = true
            self.deleteButton.tintColor = UIColor.redColor()
            
        }else{
            self.deleteButton.tintColor = UIColor.clearColor()
            self.deleteButton.enabled = false;
        }
        var userImageFile:PFFile? = nil
        
        userImageFile = user["profileImage"] as? PFFile
        if userImageFile != nil {
            userImageFile!.getDataInBackgroundWithBlock {
                (imageData: NSData!, error: NSError!) -> Void in
                if error == nil {
                    self.userProfilePicture.image = UIImage(data:imageData)
                }
            }
        }
        
        self.userProfilePicture = prettifyImage(self.userProfilePicture)
        
        var entryTitle:String = entry["title"] as String!
        var entryText:String = entry["content"] as String!
        
        self.heartCount.text = String(ParseQueries.getHeartCountForEntry(self.entry))
        self.postTitle.text = entryTitle
        self.postBody.text = entryText
        assignDate(self.entry.createdAt)
        
        self.postBody.textColor = UIColor.whiteColor()
        self.postBody.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        
        showCommentsVisualView.layer.borderWidth = 1.0
        showCommentsVisualView.layer.borderColor = UIColor.whiteColor().CGColor
        
        var query = PFQuery(className: "Activity")
        query.whereKey("entry", equalTo: entry)
        query.whereKey("fromUser", equalTo: PFUser.currentUser())
        query.whereKey("type", equalTo: "like")
        var likes = query.findObjects()
        
        if likes.count > 0 {
            self.heartLike.tintColor = UIColor.redColor()
            self.heartLike.setImage(UIImage(named: "HeartRed"), forState: .Normal)
        }
        
        getCommentsForEntry()
        
    }
    
    func prettifyImage(imageViewToModify: UIImageView) -> UIImageView{
        imageViewToModify.layer.cornerRadius = imageViewToModify.frame.size.width / 2;
        imageViewToModify.clipsToBounds = true;
        imageViewToModify.layer.borderWidth = 1.0
        imageViewToModify.layer.borderColor = UIColor.whiteColor().CGColor;
        return imageViewToModify
    }
    
    func getCommentsForEntry() {
        var query = PFQuery(className: "Activity")
        query.whereKey("type", equalTo: "comment")
        query.whereKey("entry", equalTo: self.entry)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.comments = objects
                self.commentsTable.reloadData()
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    func assignDate(date:NSDate) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        self.dateWeekday.text = dateFormatter.stringFromDate(date)
        
        dateFormatter.setLocalizedDateFormatFromTemplate("dd")
        self.dateDay.text = dateFormatter.stringFromDate(date)
        
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
        self.dateMonth.text = dateFormatter.stringFromDate(date)
        
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYY")
        self.dateYear.text = dateFormatter.stringFromDate(date)
    }
    
    @IBAction func touchShare(sender: AnyObject) {
        let firstActivityItem = entry["title"] as String!
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.shareButton
        activityViewController.popoverPresentationController?.sourceRect = CGRectMake(self.shareButton.frame.width/2, 0, 0, 0)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func clickDelete(sender: AnyObject) {
        
        var alert = UIAlertController(title: "DELETE ENTRY", message: "Are you sure you want to delete this entry?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: {(alert: UIAlertAction!) in (self.deleteEntry())}))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in println("No Delete")}))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteEntry(){
        self.entry.deleteEventually()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func heartPost(sender: AnyObject) {
        
        var newHeartCount = 0
        var query = PFQuery(className: "Activity")
        query.whereKey("fromUser", equalTo: PFUser.currentUser())
        query.whereKey("toUser", equalTo: self.entry["user"] as PFUser)
        query.whereKey("entry", equalTo: self.entry)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if objects.count == 0 {
                    self.heartLike.tintColor = UIColor.redColor()
                    self.heartLike.setImage(UIImage(named: "HeartRed"), forState: .Normal)
                    newHeartCount = self.heartCount.text!.toInt()! + 1
                    self.heartCount.text = String(newHeartCount)
                    self.entry["user"].fetchIfNeededInBackgroundWithBlock {
                        (object: PFObject!, error: NSError!) -> Void in
                        if error == nil {
                            
                            var activity = PFObject(className: "Activity")
                            activity["fromUser"] = PFUser.currentUser()
                            activity["toUser"] = object as PFUser
                            activity["type"] = "like"
                            activity["entry"] = self.entry
                            activity.saveInBackground()
                            
                        } else {
                            NSLog("Error: %@ %@", error, error.userInfo!)
                        }
                    }
                } else {
                    objects[0].deleteInBackground()
                    self.heartLike.tintColor = UIColor.whiteColor()
                    self.heartLike.setImage(UIImage(named: "HeartWhite"), forState: .Normal)
                    newHeartCount = self.heartCount.text!.toInt()! - 1
                    self.heartCount.text = String(newHeartCount)
                }
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    
    
    func setupTheHamburgerIcon() {
        self.button = HamburgerButton(frame: CGRectMake(20, 20, 60, 60))
        self.button.addTarget(self, action: "toggle:", forControlEvents:.TouchUpInside)
        self.button.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        // self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: self.button)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    func toggle(sender: AnyObject!) {
        self.button.showsMenu = !self.button.showsMenu
    }

    @IBAction func commentButtonClicked(sender: UIButton) {
        var currentFrame = showCommentsVisualView.frame
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        
        if (showCommentsToggle){
            showCommentsVisualView.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y-300, currentFrame.size.width, currentFrame.size.height+300)
            sender.layer.backgroundColor = UIColor.blackColor().CGColor
            sender.setTitle("Hide Comments", forState: UIControlState.Normal)
            showCommentsToggle = !showCommentsToggle
        }else{
            showCommentsVisualView.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y+300, currentFrame.size.width, currentFrame.size.height-300)
            sender.layer.backgroundColor = UIColor.clearColor().CGColor
            sender.setTitle("Show Comments", forState: UIControlState.Normal)
            showCommentsToggle = !showCommentsToggle
        }
        
        UIView.commitAnimations()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.commentsTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var comment:PFObject = self.comments[indexPath.row] as PFObject
        var user:PFUser = comment["fromUser"] as PFUser
        user.fetchIfNeeded()
        
        var cell:CommentCell = tableView.dequeueReusableCellWithIdentifier("commentCell") as CommentCell
        cell.userName.text = user.username
        cell.theComment.text = (comment["content"] as String)
        cell.backgroundColor = UIColor.clearColor()
        
        var userImageFile:PFFile? = user["profileImage"] as? PFFile
        var imageData = userImageFile?.getData()
        if imageData != nil {
            cell.userProfilePicture.image = UIImage(data: imageData!)
        }
        
        
        return cell
    }
    
    func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 100
    }
    
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        if self.entry["location"].latitude != 0.0 && self.entry["location"].longitude != 0.0{
            self.performSegueWithIdentifier("entryToMapView", sender: sender)
        }else{
            let alertController = UIAlertController(title: "Sorry!", message:
                "There is no location attached to this post.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func submitCommentButtonTapped(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Submit new comment", message: nil, preferredStyle: .Alert)

        let submitAction = UIAlertAction(title: "Submit", style: .Default) { (_) in
            var newComment = PFObject(className: "Activity")
            newComment["fromUser"] = PFUser.currentUser()
            newComment["toUser"] = self.entry["user"]
            newComment["type"] = "comment"
            newComment["content"] = (alertController.textFields![0] as UITextField).text
            newComment["entry"] = self.entry
            newComment.saveInBackgroundWithBlock {
                (success: Bool!, error: NSError!) -> Void in
                if (success != nil) {
                    self.getCommentsForEntry()
                } else {
                    NSLog("%@", error)
                }
            }
        }
        submitAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Your comment..."
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                submitAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "entryToMapView"{
            let vc = segue.destinationViewController as MapViewController
            vc.currentEntry = self.entry as PFObject
        }
    }
    

    
}
