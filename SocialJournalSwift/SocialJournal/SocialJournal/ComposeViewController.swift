//
//  ComposeViewController.swift
//  SocialJournal
//
//  Created by Gabe on 11/17/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit
import CoreLocation

class ComposeViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    var button: HamburgerButton! = nil
    var locationManager: CLLocationManager!
    
    //main view
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    
    //date view
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    //add media view
    @IBOutlet weak var addMediaView: UIView!
    @IBOutlet weak var addMediaButton: UIButton!
    
    //media view
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var mediaImageView: UIImageView!
    
    //buttons view
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var urlNameTextField: UITextField!
    @IBOutlet weak var urlDestinationTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var removeImageButton: UIButton!
    
    var currentEntry = PFObject(className: "Entry")
    var virtualNameDictionary = Dictionary<String,String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        // self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()

        self.button = HamburgerButton(frame: CGRectMake(20, 20, 60, 60))
        self.button.addTarget(self, action: "toggle:", forControlEvents:.TouchUpInside)
        self.button.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        // self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: self.button)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
     
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        self.weekdayLabel.text = dateFormatter.stringFromDate(NSDate())
        
        dateFormatter.dateFormat = "MMMM"
        self.monthLabel.text = dateFormatter.stringFromDate(NSDate())
        
        dateFormatter.dateFormat = "dd"
        self.dateLabel.text = dateFormatter.stringFromDate(NSDate())
        
        dateFormatter.dateFormat = "yyyy"
        self.yearLabel.text = dateFormatter.stringFromDate(NSDate())
        
        var userImageFile:PFFile? = nil
        
        userImageFile = PFUser.currentUser()["profileImage"] as? PFFile
        if userImageFile != nil {
            userImageFile!.getDataInBackgroundWithBlock {
                (imageData: NSData!, error: NSError!) -> Void in
                if error == nil {
                    self.profilePictureImageView.image = UIImage(data:imageData)
                }
                self.profilePictureImageView = self.prettifyImage(self.profilePictureImageView)
            }
        }
        
       
        getVirtualNamesFromNSUserDefaults()
        // Do any additional setup after loading the view.
    }
    
    func prettifyImage(imageViewToModify: UIImageView) -> UIImageView{
        imageViewToModify.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2;
        imageViewToModify.clipsToBounds = true;
        imageViewToModify.layer.borderWidth = 1.0
        imageViewToModify.layer.borderColor = UIColor.whiteColor().CGColor;
        return imageViewToModify
    }
    
    func getVirtualNamesFromNSUserDefaults(){
        var userDefaults = NSUserDefaults.standardUserDefaults()
        if let virtualNames = userDefaults.objectForKey("virtualNamesDictionary") as? Dictionary<String,String>{
            self.virtualNameDictionary = virtualNames
            //println(virtualNames)
        }
    }
    
    func replaceVirtualNames(text:String) -> String{
        var result = text
        for(key,value) in self.virtualNameDictionary{
            result = text.stringByReplacingOccurrencesOfString(key, withString: value, options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        //println(result)
        return result as String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTagsFromTitleAndContent() -> Array<String> {
        //get the tags here, if no tags return an empty array ... not nil
        var result = [String]();
    
        //initialize the arrays
        var titleTags = self.titleTextField.text.componentsSeparatedByString(" ")
        var contentTags = self.contentTextView.text.componentsSeparatedByString(" ")
        var allTags = titleTags + contentTags
    
        var tagDictionary = [String: Int]()
    
        for word in allTags{
            if countElements(word) != 0{
                var temp = (word as NSString).substringToIndex(1)
            
                if (temp == "#" && countElements(word) > 1 &&
                    word.substringFromIndex(advance(word.startIndex, 1)).rangeOfString("#") == nil &&
                    tagDictionary[word] == nil){
                        tagDictionary[word] = allTags.count
                        result.append(word)
                        //println(word)
                }
            }
        }
        //println(result)
        return result;
    }
    
    func saveTagsFromPost(entry:PFObject, tags:Array<String>) {
        let tags = getTagsFromTitleAndContent()
        if (!tags.isEmpty) {
            for tag in tags {
                var query = PFQuery(className: "Tags")
    
                query.whereKey("tag", equalTo: tag)
                query.getFirstObjectInBackgroundWithBlock {
                    (foundTag: PFObject!, error: NSError!) -> Void in
                    if foundTag != nil {
                        var newTag = PFObject(className: "Tags")
    
                        newTag["tag"] = tag
                        newTag.save()
    
                        var newTagMapEntry = PFObject(className: "TagMap")
    
                        newTagMapEntry["entry"] = entry
                        newTagMapEntry["tag"] = newTag
                        newTagMapEntry.saveEventually()
                    } else {
                        var newTagMapEntry = PFObject(className: "TagMap")
    
                        newTagMapEntry["entry"] = entry
                        newTagMapEntry["tag"] = foundTag
                        newTagMapEntry.saveEventually()
                    }
                }
                    
            }
        }
    }
    
    //shows the main add media view, allowing access to all of its subviews
    @IBAction func addMediaButtonPushed(sender: AnyObject) {
        self.addMediaView.alpha = 1.0
        self.addMediaButton.alpha = 0.0
        self.mediaView.alpha = 1.0
        self.buttonsView.alpha = 1.0
        
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.presentViewController(pickerC, animated: true, completion: nil)
    }
    
    @IBAction func postNewEntry(sender: AnyObject) {
        
        if self.titleTextField.text != "" && self.contentTextView.text != ""{
            self.currentEntry["user"] = PFUser.currentUser()
            self.currentEntry["content"] = self.replaceVirtualNames(self.contentTextView.text)
            self.currentEntry["title"] = self.replaceVirtualNames(self.titleTextField.text)
            
            //check to make sure location isnt nil
            if self.locationManager.location == nil{
                self.currentEntry["location"] = PFGeoPoint(latitude: 0.0, longitude: 0.0)
            }else{
                self.currentEntry["location"] = PFGeoPoint(latitude:NSString(string: self.locationManager.location.coordinate.latitude.description).doubleValue, longitude:NSString(string: self.locationManager.location.coordinate.longitude.description).doubleValue)
            }
            
            //
            
            if self.mediaImageView.image != nil {
                let imageData = UIImageJPEGRepresentation(self.mediaImageView.image, 0.05)
                let imageFile = PFFile(name: "image.jpg", data: imageData)
                self.currentEntry["image"] = imageFile
            }
            
            self.currentEntry.saveInBackgroundWithBlock{
                (success: Bool!, error:NSError!) -> Void in
                
                if success! {
                    var query = PFQuery(className:"Entry")
                    query.getObjectInBackgroundWithId(self.currentEntry.objectId) {
                        (entry: PFObject!, error: NSError!) -> Void in
                        if error == nil {
                            self.currentEntry = entry
                            //Preform segue here
                            self.performSegueWithIdentifier("composeToEntryView", sender: sender)
                        } else {
                            //if failure, give an alert
                            let alertController = UIAlertController(title: "Oops!", message:
                                "Something went wrong, we were unable to process your new post.", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    //if failure, give an alert
                    let alertController = UIAlertController(title: "Oops!", message:
                        "Something went wrong, we were unable to process your new post.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }else { // if either the title or content is empty
            let alertController = UIAlertController(title: "Incomplete Post", message: "Please make sure the Title and Content are not empty.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    func toggle(sender: AnyObject!) {
        self.button.showsMenu = !self.button.showsMenu
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //println("updating location")
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                //println(pm.locality);
            }
        })
    }
    
    @IBAction func editImage(sender: AnyObject) {
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.presentViewController(pickerC, animated: true, completion: nil)
    }
    
    @IBAction func removeImage(sender: AnyObject) {
        self.mediaImageView.image = nil
        self.backgroundImageView.image = UIImage(named: "Lake")
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.mediaImageView.alpha = 1.0
        self.addMediaButton.alpha = 0.0
        self.mediaImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.backgroundImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "composeToEntryView"{
            let vc = segue.destinationViewController as EntryViewController
            vc.entry = self.currentEntry as PFObject
            vc.navigationItem.setHidesBackButton(true, animated: true)
        }
    }

}
