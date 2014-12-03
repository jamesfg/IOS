//
//  SignInController.m
//  SocialJournal
//
//  Created by Muhammad Naviwala on 11/10/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "SignInController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
//#import "RegisterationController.h"
#import <Parse/Parse.h>

@interface SignInController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation SignInController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spinner.center = CGPointMake(540, 580);
    self.spinner.hidesWhenStopped = YES;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    self.spinner.transform = transform;
    [self.view addSubview:self.spinner];
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

- (IBAction)signInButtonClicked:(id)sender {
    if ([self userInputIsValid] ) {
        NSLog(@"Username: %@\nPassword: %@", self.userNameText.text, self.passwordText.text);
        
        [self.spinner startAnimating];
        dispatch_queue_t queue = dispatch_get_global_queue(0,0);
        dispatch_async(queue, ^{
            [self signIn];
            dispatch_sync(dispatch_get_main_queue(), ^{
                // [self.spinner stopAnimating];
            });
        });
        
    }else {
        [self displayAlertView:@"Error" :@"All fields are required" :@"Ok"];
    }

}

- (void) signIn{
    [PFUser logInWithUsernameInBackground:self.userNameText.text password:self.passwordText.text block:^(PFUser *user, NSError *error){
        if (user) {
            [self displayAlertView:@"Success" :@"You have successfully signed in, and can start using the app" :@"Ok"];
            // segue HERE
            
            // If you want to segue to the registration controller
            // [self performSegueWithIdentifier:@"segueToRegisterationFromSignIn" sender:self];
            
            
            UISplitViewController *split = [self.storyboard instantiateViewControllerWithIdentifier:@"THE_SplitViewController"];
            self.view.window.rootViewController = split;

        }else{
            [self displayAlertView:@"Error" :[error userInfo][@"error"] :@"Ok"];
        }
    }];
}

- (BOOL)userInputIsValid{
    if (![self stringIsNilOrEmpty:self.userNameText.text] && ![self stringIsNilOrEmpty:self.passwordText.text]){
        return TRUE;
    }
    else{
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

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    NSLog(@"Inside prepare for segue");
//    if([segue.identifier isEqualToString:@"segueToSplitView"])
//    {
//        DetailViewController *transferViewController = segue.destinationViewController;
//    }
//    
//    if([segue.identifier isEqualToString:@"segueToRegisterationFromSignIn"])
//    {
//        RegisterationController *transferViewController = segue.destinationViewController;
//    }
//}

@end
