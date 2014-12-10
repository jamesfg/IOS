//
//  SettingsViewController.swift
//  SocialJournal
//
//  Created by Gabe on 11/17/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var heartsLabel: UILabel!
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var button: HamburgerButton! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
        self.followingLabel.layer.cornerRadius = 8
        self.followingLabel.layer.masksToBounds = true
        self.commentsLabel.layer.cornerRadius = 8
        self.commentsLabel.layer.masksToBounds = true
        self.heartsLabel.layer.cornerRadius = 8
        self.heartsLabel.layer.masksToBounds = true
        
        let userImageFile = PFUser.currentUser()["profileImage"] as? PFFile
        
        if userImageFile != nil {
            userImageFile!.getDataInBackgroundWithBlock {
                (imageData: NSData!, error: NSError!) -> Void in
                if error == nil {
                    self.userProfilePicture.image = UIImage(data:imageData)
                }
                self.userProfilePicture = self.prettifyImage(self.userProfilePicture)
            }
        } else {
            self.userProfilePicture = self.prettifyImage(self.userProfilePicture)
        }


        setupTheHamburgerIcon()
        userNameLabel.text = PFUser.currentUser().username
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
    
    func prettifyImage(imageViewToModify: UIImageView) -> UIImageView{
        imageViewToModify.layer.cornerRadius = imageViewToModify.frame.size.width / 2;
        imageViewToModify.clipsToBounds = true;
        imageViewToModify.layer.borderWidth = 1.0
        imageViewToModify.layer.borderColor = UIColor.whiteColor().CGColor;
        return imageViewToModify
    }
    
    func toggle(sender: AnyObject!) {
        self.button.showsMenu = !self.button.showsMenu
    }

    @IBAction func changePassword(sender: AnyObject) {
        
        //let alertController: UIAlertController = UIAlertController(title: "Change Your Password", message: "Swiftly Now! Choose an option!", preferredStyle: .ActionSheet)
        
        let alertController = UIAlertController(title: "Change Your Password", message: "A standard alert.", preferredStyle: .Alert)
        
        //Create and add the Cancel action

            
        let cancelAction = UIAlertAction(title: "Cancel",style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in })
        
        alertController.addAction(cancelAction)
        //Create and add first option action
        
        let confirmAction = UIAlertAction(title: "Confirm",style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            var currentUser = PFUser.currentUser()
            
            if let textFields = alertController.textFields{
                
                let theTextFields = textFields as [UITextField]
                
                let oldPassword = theTextFields[0].text
                let newPassword = theTextFields[1].text
                let confirmPassword = theTextFields[2].text
              /*  if currentUser.password != oldPassword{
                    
                    let alertController3 = UIAlertController(title: "Error", message: "Old Password is wrong", preferredStyle: .Alert)
                    
                    let OkAction = UIAlertAction(title: "OK",style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in })
                    
                    alertController3.addAction(OkAction)
                    alertController3.popoverPresentationController?.sourceView = sender as UIView;
                    self.presentViewController(alertController3, animated: true, completion: nil)

                    
                }*/
                
                if confirmPassword != newPassword{
                    let alertController2 = UIAlertController(title: "Error", message: "New and Confirm password Doesn't Match", preferredStyle: .Alert)
                    
                    let OkAction = UIAlertAction(title: "OK",style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in })
                    
                    alertController2.addAction(OkAction)
                    alertController2.popoverPresentationController?.sourceView = sender as UIView;
                    self.presentViewController(alertController2, animated: true, completion: nil)
                }
                
                currentUser.password = newPassword
                currentUser.saveInBackground()
            }
            
        
        })
        
        alertController.addAction(confirmAction)
        
       /* let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) { action -&gt; Void in
            //Code for launching the camera goes here
        }*/
        //actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
       
       alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Old Password"
            //textField.keyboardType = .EmailAddress
            textField.secureTextEntry = true
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "New Password"
            textField.secureTextEntry = true
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "New Password Confirmation"
            textField.secureTextEntry = true
        }
        
        //We need to provide a popover sourceView when using it on iPad
        alertController.popoverPresentationController?.sourceView = sender as UIView;
        
        //Present the AlertController
        self.presentViewController(alertController, animated: true, completion: nil)
     
        
    }
    
    
    @IBAction func signOut(sender: AnyObject) {
    
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("signInView") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
   
    
    }
    
    @IBOutlet weak var followingSwitch: UISwitch!
    
    @IBOutlet weak var commentsSwitch: UISwitch!
    
    @IBOutlet weak var heartsSwitch: UISwitch!
    

    
    func checkfollowingNotification(){
        
        if self.followingSwitch.on{
            
            //code for turn on the followingNotification
            
        }
            else{
            
            //code for turn off the followingNotification
            
        }
        
    }

    func checkcommentsNotification(){
            
            if self.commentsSwitch.on{
            //code for turn on the COMMENTSNotification
            }
            else{
            //code for turn off the commentsNotification
            }
    }
    
    func checkheartsNotification(){
                if self.heartsSwitch.on{
                //code for turn on the hearts notification

               }else{
                //code for turn off the hearts notification
                }
                
                
        
    }

    @IBAction func changeProfilePictureButtonClicked(sender: UIButton) {
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        self.presentViewController(pickerC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //resize the image
        UIGraphicsBeginImageContext(CGSizeMake(500, 500))
        image!.drawInRect(CGRectMake(0, 0, 500, 500))
        self.userProfilePicture.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageData = UIImageJPEGRepresentation(self.userProfilePicture.image, 0.05)
        let imageFile = PFFile(name:"profile.jpg", data:imageData)
        
        var user = PFUser.currentUser()
        user["profileImage"] = imageFile
        user.saveInBackground()
    }
    
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
