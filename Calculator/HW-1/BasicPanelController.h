//
//  BasicPanelController.h
//  HW-1
//
//  Created by Muhammad Naviwala on 9/21/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIViewController.h"

@interface BasicPanelController : CustomUIViewController
@property (nonatomic) BOOL typingNumber; //check if user is typing a number
@property (nonatomic) float firstNumber;
@property (nonatomic) float secondNumber;
@property (nonatomic, copy) NSString *operation; // +,-,*,/ operation

- (IBAction)backSpace:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *calculationDisplay;

- (IBAction)numberPressed:(UIButton *)sender;
- (IBAction)clearPressed:(UIButton *)sender;
- (IBAction)calculationPressed:(id)sender;
- (IBAction)equalPressed:(UIButton *)sender;



@end
