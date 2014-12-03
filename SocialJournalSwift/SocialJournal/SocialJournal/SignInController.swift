//
//  SignInController.swift
//  PlayingWithAnimations
//
//  Created by Muhammad Naviwala on 11/15/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

import UIKit

class SignInController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonClicked(sender: UIButton) {
//        let queue = dispatch_get_global_queue(0,0)
//        dispatch_async(queue, {
//            self.animateMask()
//            dispatch_sync(dispatch_get_main_queue(), {
//                self.performSegueWithIdentifier("segueToProfileViewController", sender: self)
//            })
//        })

//        let delayTime = 0.7
//        
//        basicAnimation()
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
//            self.performSegueWithIdentifier("segueToProfileViewController", sender: self)
//        });

        spinner.startAnimating()
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password:passwordTextField.text) {
            (user: PFUser!, error: NSError!) -> Void in
            self.spinner.stopAnimating()
            if user != nil {
                self.basicAnimation()
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.7 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("swRevealController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                });
                // Do stuff after successful login.
            } else {
                // The login failed. Check error to see why.
                let errorString = error.userInfo?["error"] as? NSString
                let alertView = UIAlertView(title: "Error", message: errorString?.capitalizedString, delegate: self, cancelButtonTitle: "Ok")
                alertView.show()
            }
        }
        
    }
    
    func basicAnimation() {
        self.whiteView.alpha = 0
        self.whiteView.layer.zPosition = 10 // make sure the white view is on the very top
        UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: {
            self.whiteView.alpha = 1
            }, completion: { finished in
                // do something for completion of needed
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == usernameTextField){
            passwordTextField.becomeFirstResponder()
        }
        if(textField == passwordTextField){
            passwordTextField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.3)
        self.view.bounds.origin.y = 200
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.3)
        self.view.bounds.origin.y = 0
        UIView.commitAnimations()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
}