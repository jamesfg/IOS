//
//  CommentTableViewCell.h
//  SocialJournal
//
//  Created by Muhammad Naviwala on 11/12/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *commentText;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *dateAndCoordinates;

@end

