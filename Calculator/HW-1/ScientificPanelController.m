//
//  ScientificPanelController.m
//  HW-1
//
//  Created by Muhammad Naviwala on 9/21/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScientificPanelController.h"
#import "MathLibrary.h"

@interface ScientificPanelController ()

@property float firstNumber;
@property float secondNumber;
@property NSString *operation;
@property float e;

@end

@implementation ScientificPanelController


- (IBAction)numberPressed:(id)sender {
    NSString *theNumber = [sender currentTitle];
    NSString *display;
    if([theNumber isEqualToString:@"."]){
        display = @"0.";
    }else{
        display = [self.inputLabel.text stringByAppendingString:theNumber];
    }
    self.inputLabel.text = display;
}

- (IBAction)equalsButtonPressed:(id)sender {
    
    if([self.inputLabel.text isEqualToString:@""] || [self.inputLabel.text isEqualToString:@"0"])
        self.inputLabel.text = @"0";
    else{
        self.secondNumber = [self.inputLabel.text floatValue];
        self.inputLabel.text = @"";
    }
    
    //Modulus Button
    if([self.operation isEqualToString:@"Modulus"]){
        //self.inputLabel.text = self.operation;
        //self.inputLabel.text = [NSString stringWithFormat:@"%f", self.secondNumber];
        //float temp = (int)self.firstNumber % (int)self.secondNumber;
        //self.inputLabel.text = [NSString stringWithFormat:@"%f", temp];
        self.inputLabel.text = [NSString stringWithFormat:@"%f", [MathLibrary modulusOperand1:self.firstNumber withOperand2:self.secondNumber]];
        self.modulusButton.alpha = 1.00;
        self.modulusButton.enabled = YES;
    }
    //Power Button
    if([self.operation isEqualToString:@"Power"]){
        self.inputLabel.text = [NSString stringWithFormat:@"%f", [MathLibrary exponetBase:self.firstNumber raiseTo:self.secondNumber]];
        self.powerButton.alpha = 1.00;
        self.powerButton.enabled = YES;
    }
}

- (IBAction)clearButtonPressed:(id)sender {
    [self clear];
}

/*
 Removes one number from the end of the current input label until empty, and then does nothing
 */
- (IBAction)backspaceButtonPressed:(id)sender {
    if(self.inputLabel.text.length > 0 )
        self.inputLabel.text =  [self.inputLabel.text substringWithRange:NSMakeRange(0, self.inputLabel.text.length - 1)];
}

/*  uses "MathLibrary.h"
 Checks if input is empty or 0, if not it calls sineUsingDegrees with the current input
 */
- (IBAction)sinButtonPressed:(id)sender {
    if([self.inputLabel.text isEqualToString:@""] || [self.inputLabel.text isEqualToString:@"0"])
        self.inputLabel.text = @"0";
    else
        self.inputLabel.text = [NSString stringWithFormat:@"%f", [MathLibrary sineUsingDegrees:[self.inputLabel.text floatValue]]];
}

/*  uses "MathLibrary.h"
 Checks if input is empty or 0, if not it calls log with the current input
 */
- (IBAction)logButtonPressed:(id)sender {
    if([self.inputLabel.text isEqualToString:@""] || [self.inputLabel.text isEqualToString:@"0"])
        self.inputLabel.text = @"0";
    else
        self.inputLabel.text = [NSString stringWithFormat:@"%f", [MathLibrary log:[self.inputLabel.text floatValue]]];
}

/*
 Performs some setup for the modulus function:
    1) assigns current input to self.firstNumber
    2) clears input
    3) sets current operation to Modulus
    4) enables/disables self.modulusButton
 */
- (IBAction)modulusButtonPressed:(id)sender {
    self.firstNumber = [self.inputLabel.text floatValue];
    self.inputLabel.text = @"";
    
    self.modulusButton.enabled = !self.modulusButton.enabled;
    if(self.modulusButton.enabled == NO){
        self.operation = @"Modulus";
        self.modulusButton.alpha = 0.50;
    }else{
        self.operation = @"";
        self.modulusButton.alpha = 1.00;
    }
    
}

/*  uses "MathLibrary.h"
 Checks if input is empty or 0, if not it calls squareRoot with the current input
 */
- (IBAction)sqrtButtonPressed:(id)sender {
    if([self.inputLabel.text isEqualToString:@""] || [self.inputLabel.text isEqualToString:@"0"])
        self.inputLabel.text = @"0";
    else
        self.inputLabel.text = [NSString stringWithFormat:@"%f", [MathLibrary squareRoot:[self.inputLabel.text floatValue]]];
}

/*
 Performs some setup for the power function:
    1) assigns current input to self.firstNumber
    2) clears input
    3) sets current operation to Power
    3) enables/disables self.modulusButton
 */
- (IBAction)powerButtonPressed:(id)sender {
    self.firstNumber = [self.inputLabel.text floatValue];
    self.inputLabel.text = @"";
    
    self.powerButton.enabled = !self.powerButton.enabled;
    if(self.powerButton.enabled == NO){
        self.operation = @"Power";
        self.powerButton.alpha = 0.50;
    }else{
        self.operation = @"";
        self.powerButton.alpha = 1.00;
    }
    
}

/* uses "MathLibrary.h"
 Checks to see if the input is empty, if so the input becomes the value of 'e'
 otherwise raise the current input to the power of e
 */
- (IBAction)exponentButtonPressed:(id)sender {
    if([self.inputLabel.text isEqualToString:@""]){
        self.inputLabel.text = [NSString stringWithFormat:@"%f", self.e];
    }else{
        self.firstNumber = [self.inputLabel.text floatValue];
        self.inputLabel.text = [NSString stringWithFormat:@"%f", [MathLibrary exponetBase:self.firstNumber raiseTo: self.e]];
    }
}

/* uses "MathLibrary.h"
 Checks if input is empty or 0, if not it calls factorial with the current input
 */
- (IBAction)factorialButtonPressed:(id)sender {
    if([self.inputLabel.text isEqualToString:@""] || [self.inputLabel.text isEqualToString:@"0"])
        self.inputLabel.text = @"0";
    else
        self.inputLabel.text = [NSString stringWithFormat:@"%d", [MathLibrary factorial:[self.inputLabel.text intValue]]];
}

/*
 Reset all buttons, clear all input
 */
- (void)clear{
    self.inputLabel.text = @"";
    self.firstNumber = 0;
    self.secondNumber = 0;
    
    self.sinButton.alpha = 1.00;
    self.logButton.alpha = 1.00;
    self.modulusButton.alpha = 1.00;
    self.sqrtButton.alpha = 1.00;
    self.powerButton.alpha = 1.00;
    self.exponentButton.alpha = 1.00;
    self.factorialButton.alpha = 1.00;
    
    self.sinButton.enabled = YES;
    self.logButton.enabled = YES;
    self.modulusButton.enabled = YES;
    self.sqrtButton.enabled = YES;
    self.powerButton.enabled = YES;
    self.exponentButton.enabled = YES;
    self.factorialButton.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.e = 2.71828182845904523536;
    [self clear];
    self.previousOperationLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
