//
//  HexPanelController.h
//  HW-1
//
//  Created by Muhammad Naviwala on 9/21/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIViewController.h"

@interface HexPanelController : CustomUIViewController
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *backspaceButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *equalsButton;
@property (weak, nonatomic) IBOutlet UIButton *FButton;
@property (weak, nonatomic) IBOutlet UIButton *EButton;
@property (weak, nonatomic) IBOutlet UIButton *DButton;
@property (weak, nonatomic) IBOutlet UIButton *CButton;
@property (weak, nonatomic) IBOutlet UIButton *BButton;
@property (weak, nonatomic) IBOutlet UIButton *AButton;
@property (weak, nonatomic) IBOutlet UIButton *zeroButton;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveButton;
@property (weak, nonatomic) IBOutlet UIButton *sixButton;
@property (weak, nonatomic) IBOutlet UIButton *sevenButton;
@property (weak, nonatomic) IBOutlet UIButton *eightButton;
@property (weak, nonatomic) IBOutlet UIButton *nineButton;
@property (weak, nonatomic) IBOutlet UILabel *binaryOutput;
@property (weak, nonatomic) IBOutlet UILabel *decimalOutput;
@property (weak, nonatomic) IBOutlet UILabel *hexOutput;
@property (weak, nonatomic) IBOutlet UIButton *binButton;
@property (weak, nonatomic) IBOutlet UIButton *decButton;
@property (weak, nonatomic) IBOutlet UIButton *hexButton;

@end
