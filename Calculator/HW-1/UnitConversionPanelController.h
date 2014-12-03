//
//  UnitConversionPanelController.h
//  HW-1
//
//  Created by Muhammad Naviwala on 9/21/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIViewController.h"

@interface UnitConversionPanelController : CustomUIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerMeasurementType;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerConvertFrom;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerConvertTo;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UITextField *convertedNumberDisplay;
@property (weak, nonatomic) IBOutlet UITextField *userInput;
- (IBAction)userInputChanged:(id)sender;
@end
