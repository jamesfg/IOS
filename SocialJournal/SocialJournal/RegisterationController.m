//
//  RegisterationController.m
//  SocialJournal
//
//  Created by Muhammad Naviwala on 11/9/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "RegisterationController.h"
#import <Parse/Parse.h>

@interface RegisterationController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordText;

@end

@implementation RegisterationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.view endEditing:YES];
    }
}

- (IBAction)regiserButtonClicked:(id)sender {
    if ([self userInputIsValid] && [self passwordsMatch]) {
        NSLog(@"Username: %@\nPassword: %@", self.userNameText.text, self.passwordText.text);
        [self signUp];
    }else if (![self userInputIsValid]){
        [self displayAlertView:@"Error" :@"All fields are required" :@"Ok"];
    }else if(![self passwordsMatch]){
        [self displayAlertView:@"Error" :@"Password and Confirm Password have to match" :@"Ok"];
    }
}

- (void) signUp {
    PFUser *user = [PFUser user];
    user.username = self.userNameText.text;
    user.password = self.passwordText.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self displayAlertView:@"Success" :@"You have successfully registered, and can start using the app" :@"Ok"];
            
            UISplitViewController *split = [self.storyboard instantiateViewControllerWithIdentifier:@"THE_SplitViewController"];
            self.view.window.rootViewController = split;
            
        }else{
            [self displayAlertView:@"Error" :[error userInfo][@"error"] :@"Ok"];
        }
    }];
}

- (BOOL)userInputIsValid{
    if (![self stringIsNilOrEmpty:self.userNameText.text] && ![self stringIsNilOrEmpty:self.passwordText.text] && ![self stringIsNilOrEmpty:self.confirmPasswordText.text]){
        return TRUE;
    }
    else{
        return FALSE;
    }
}

- (BOOL) passwordsMatch {
    if ([self.passwordText.text isEqualToString:self.confirmPasswordText.text]) {
        return TRUE;
    }else{
        return FALSE;
    }
}

- (BOOL)stringIsNilOrEmpty:(NSString*)aString {
    return !(aString && aString.length);
}

- (void)displayAlertView:(NSString*)title :(NSString*)message :(NSString*)cancelButtonTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alert show];
}

@end
