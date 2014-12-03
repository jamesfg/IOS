//
//  EntryViewController.h
//  SocialJournal
//
//  Created by James Garcia on 11/9/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EntryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property PFObject *entry;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSArray *pfComments;
@property (strong, nonatomic) NSArray *usersOfComments;

@end
