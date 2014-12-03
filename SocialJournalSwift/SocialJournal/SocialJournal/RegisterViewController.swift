//
//  RegisterViewController.swift
//  SocialJournal
//
//  Created by Gabe on 11/18/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var whiteView: UIView!

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func registerButtonPushed(sender: UIButton) {
        if !verifyFields() {
            //pop alertView or notify user
            return
        }
        var user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        spinner.startAnimating()
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            self.spinner.stopAnimating()
            if error == nil {
                self.basicAnimation()
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.7 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("swRevealController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                });
                println(PFUser.currentUser().username)
            } else {
                let errorString = error.userInfo!["error"] as NSString
                // Show the errorString somewhere and let the user try again.
            }
        }
    }
    
    func verifyFields() -> Bool {
        return (usernameTextField.text != nil && passwordTextField.text != nil && passwordTextField.text == confirmPasswordTextField.text)
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
            confirmPasswordTextField.becomeFirstResponder()
        }
        if(textField == confirmPasswordTextField){
            confirmPasswordTextField.resignFirstResponder()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
