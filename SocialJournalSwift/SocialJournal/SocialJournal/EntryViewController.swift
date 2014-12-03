//
//  EntryViewController.swift
//  SocialJournal
//
//  Created by James Garcia on 11/19/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var showCommentsVisualView: UIVisualEffectView!
    var showCommentsToggle = true
    @IBOutlet weak var commentsTable: UITableView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userProfilePicture.layer.cornerRadius = 50
        self.userProfilePicture.layer.masksToBounds = true
        
        //
        
        entry["user"].fetchIfNeededInBackgroundWithBlock {
            (object: PFObject!, error: NSError!) -> Void in
            if error == nil {
                self.username.text = object["username"] as String!
                println(object["username"])
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
            
        }
        
        //        cell.userProfilePicture.image =
        
        //        if(favorited) {
        //            cell.hearted.image =
        //        }
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
        
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func heartPost(sender: AnyObject) {
        
        var query = PFQuery(className: "Activity")
        query.whereKey("fromUser", equalTo: PFUser.currentUser())
        query.whereKey("toUser", equalTo: self.entry["user"] as PFUser)
        query.whereKey("entry", equalTo: self.entry)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if objects.count == 0 {
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
                }
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }

        }
        
        let image = UIImage(named: "HeartRed") as UIImage?
        self.heartLike.setImage(image, forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 8
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:CommentCell = tableView.dequeueReusableCellWithIdentifier("commentCell") as CommentCell
        cell.userName.text = "username here"
        cell.theComment.text = "comment\nsupports 4 lines at most\nlast line"
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 100
    }
    
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        if self.entry["location"] != nil{
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
            println("Comment entered => " + (alertController.textFields![0] as UITextField).text)
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
