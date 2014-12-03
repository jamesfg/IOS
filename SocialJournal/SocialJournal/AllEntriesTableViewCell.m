//
//  AllEntriesTableViewCell.m
//  SocialJournal
//
//  Created by James Garcia on 10/29/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "AllEntriesTableViewCell.h"

@implementation AllEntriesTableViewCell

- (void)awakeFromNib {
    self.profilePhoto.layer.cornerRadius = 7.0f;
    self.profilePhoto.clipsToBounds = YES;
    [self.profilePhoto.layer setBorderColor: [[UIColor colorWithRed:(49/255.0) green:(50/255.0) blue:(51/255.0) alpha:1.0] CGColor]];
    [self.profilePhoto.layer setBorderWidth: 2.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
