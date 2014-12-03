//
//  HexPanelController.m
//  HW-1
//
//  Created by Muhammad Naviwala on 9/21/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexPanelController.h"
#import "MathLibrary.h"

@interface HexPanelController ()

@property NSString *interfaceMode;

@end

@implementation HexPanelController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interfaceMode = @"binary";
    [self changeInterFace:self.interfaceMode];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pressButton:(UIButton *)sender {
    
    //clear
    if (sender == self.clearButton) {
        self.binaryOutput.text = @"";
        self.hexOutput.text = @"";
        self.decimalOutput.text = @"";
    }
    //backspace
    if (sender == self.backspaceButton) {
        [self pressNumber:self.interfaceMode :@"backspace"];
    }
    
    //interface
    if (sender == self.binButton) {
        self.interfaceMode = @"binary";
        [self changeInterFace:self.interfaceMode];
    }
    if (sender == self.decButton) {
        self.interfaceMode = @"decimal";
        [self changeInterFace:self.interfaceMode];
    }
    if (sender == self.hexButton) {
        self.interfaceMode = @"hexadecimal";
        [self changeInterFace:self.interfaceMode];
    }
    
    //text input
    if (sender == self.zeroButton) {
        [self pressNumber:self.interfaceMode :@"0"];
    }
    if (sender == self.oneButton) {
        [self pressNumber:self.interfaceMode :@"1"];
    }
    if (sender == self.twoButton) {
        [self pressNumber:self.interfaceMode :@"2"];
    }
    if (sender == self.threeButton) {
        [self pressNumber:self.interfaceMode :@"3"];
    }
    if (sender == self.fourButton) {
        [self pressNumber:self.interfaceMode :@"4"];
    }
    if (sender == self.fiveButton) {
        [self pressNumber:self.interfaceMode :@"5"];
    }
    if (sender == self.sixButton) {
        [self pressNumber:self.interfaceMode :@"6"];
    }
    if (sender == self.sevenButton) {
        [self pressNumber:self.interfaceMode :@"7"];
    }
    if (sender == self.eightButton) {
        [self pressNumber:self.interfaceMode :@"8"];
    }
    if (sender == self.nineButton) {
        [self pressNumber:self.interfaceMode :@"9"];
    }
    if (sender == self.AButton) {
        [self pressNumber:self.interfaceMode :@"A"];
    }
    if (sender == self.BButton) {
        [self pressNumber:self.interfaceMode :@"B"];
    }
    if (sender == self.CButton) {
        [self pressNumber:self.interfaceMode :@"C"];
    }
    if (sender == self.DButton) {
        [self pressNumber:self.interfaceMode :@"D"];
    }
    if (sender == self.EButton) {
        [self pressNumber:self.interfaceMode :@"E"];
    }
    if (sender == self.FButton) {
        [self pressNumber:self.interfaceMode :@"F"];
    }
}
- (void)pressNumber:(NSString *)inputField :(NSString *)inputValue
{
    if ([inputField  isEqual: @"binary"]) {
        
        if ([inputValue  isEqual: @"backspace"]) {
            if (![self.binaryOutput.text  isEqual: @""]) {
                self.binaryOutput.text = [self.binaryOutput.text substringToIndex:[self.binaryOutput.text length] - 1];
                if ([self.binaryOutput.text  isEqual: @""]) {
                    self.decimalOutput.text = @"";
                    self.hexOutput.text = @"";
                }else{
                    self.decimalOutput.text = [MathLibrary binaryToDecimal:self.binaryOutput.text];
                    self.hexOutput.text = [MathLibrary binaryToHex:self.binaryOutput.text];

                }
            }
        }else{
            NSMutableString *texter = [[NSMutableString alloc] init];
            [texter setString: self.binaryOutput.text];
            if (texter.length > 31) {
                [texter appendString:@""];
            }else{
                [texter appendString:inputValue];
            }
            self.binaryOutput.text = texter;
            self.decimalOutput.text = [MathLibrary binaryToDecimal:self.binaryOutput.text];
            self.hexOutput.text = [MathLibrary binaryToHex:self.binaryOutput.text];
        }
        
    }
    
    if ([inputField  isEqual: @"decimal"]) {
        
        if ([inputValue  isEqual: @"backspace"]) {
            if (![self.decimalOutput.text  isEqual: @""]) {
                self.decimalOutput.text = [self.decimalOutput.text substringToIndex:[self.decimalOutput.text length] - 1];
                if ([self.decimalOutput.text  isEqual: @""]) {
                    self.binaryOutput.text = @"";
                    self.hexOutput.text = @"";
                }else{
                    self.binaryOutput.text = [MathLibrary decimalToBinary:self.decimalOutput.text];
                    self.hexOutput.text = [MathLibrary decimalToHex:self.decimalOutput.text];
                }
            }
        }else{
            
            if ([inputValue isEqual:@"-"]) {
                NSMutableString *texter = [[NSMutableString alloc] init];
                NSMutableString *minusSign = [[NSMutableString alloc] init];
                [texter setString: self.decimalOutput.text];
                [minusSign setString: @"-"];
                if (texter.length > 11) {
                    [texter appendString:@""];
                }
                
                self.binaryOutput.text = [MathLibrary decimalToBinary:self.decimalOutput.text];
                self.hexOutput.text = [MathLibrary decimalToHex:self.decimalOutput.text];
            
            }else{

                NSMutableString *texter = [[NSMutableString alloc] init];
                [texter setString: self.decimalOutput.text];
                if (texter.length > 10) {
                    [texter appendString:@""];
                }else{
                    [texter appendString:inputValue];
                }
                self.decimalOutput.text = texter;
                self.binaryOutput.text = [MathLibrary decimalToBinary:self.decimalOutput.text];
                self.hexOutput.text = [MathLibrary decimalToHex:self.decimalOutput.text];

            }
        }
    }
    
    if ([inputField  isEqual: @"hexadecimal"]) {
        
        if ([inputValue  isEqual: @"backspace"]) {
            if (![self.hexOutput.text  isEqual: @""]) {
                self.hexOutput.text = [self.hexOutput.text substringToIndex:[self.hexOutput.text length] - 1];
                if ([self.hexOutput.text  isEqual: @""]) {
                    self.binaryOutput.text = @"";
                    self.decimalOutput.text = @"";
                }else{
                    self.binaryOutput.text = [MathLibrary hexToBinary:self.hexOutput.text];
                    self.decimalOutput.text = [MathLibrary hexToDecimal:self.hexOutput.text];
            
                }
            }
        }else{
            NSMutableString *texter = [[NSMutableString alloc] init];
            [texter setString: self.hexOutput.text];
            if (texter.length > 8) {
                [texter appendString:@""];
            }else{
                [texter appendString:inputValue];
            }
            self.hexOutput.text = texter;
            self.binaryOutput.text = [MathLibrary hexToBinary:self.hexOutput.text];
            self.decimalOutput.text = [MathLibrary hexToDecimal:self.hexOutput.text];
        }
    }
}

- (void)changeInterFace:(NSString *) interface
{
    [self.minusButton setAlpha:0.50];
    [self.equalsButton setAlpha:0.50];
    self.equalsButton.enabled = NO;
    self.minusButton.enabled = NO;

    if ([interface  isEqual: @"binary"]) {
        [self.zeroButton setAlpha:1.0];
        [self.oneButton setAlpha:1.0];
        self.zeroButton.enabled = YES;
        self.oneButton.enabled = YES;
        
        [self.twoButton setAlpha:0.50];
        [self.threeButton setAlpha:0.50];
        [self.fourButton setAlpha:0.50];
        [self.fiveButton setAlpha:0.50];
        [self.sixButton setAlpha:0.50];
        [self.sevenButton setAlpha:0.50];
        [self.eightButton setAlpha:0.50];
        [self.nineButton setAlpha:0.50];
        [self.AButton setAlpha:0.50];
        [self.BButton setAlpha:0.50];
        [self.CButton setAlpha:0.50];
        [self.DButton setAlpha:0.50];
        [self.EButton setAlpha:0.50];
        [self.FButton setAlpha:0.50];
        self.twoButton.enabled = NO;
        self.threeButton.enabled = NO;
        self.fourButton.enabled = NO;
        self.fiveButton.enabled = NO;
        self.sixButton.enabled = NO;
        self.sevenButton.enabled = NO;
        self.eightButton.enabled = NO;
        self.nineButton.enabled = NO;
        self.DButton.enabled = NO;
        self.EButton.enabled = NO;
        self.FButton.enabled = NO;
        self.AButton.enabled = NO;
        self.BButton.enabled = NO;
        self.CButton.enabled = NO;
        self.DButton.enabled = NO;
        self.EButton.enabled = NO;
        self.FButton.enabled = NO;
    }
    
    if ([interface  isEqual: @"decimal"]) {
        
        [self.zeroButton setAlpha:1.0];
        [self.oneButton setAlpha:1.0];
        [self.twoButton setAlpha:1.0];
        [self.threeButton setAlpha:1.0];
        [self.fourButton setAlpha:1.0];
        [self.fiveButton setAlpha:1.0];
        [self.sixButton setAlpha:1.0];
        [self.sevenButton setAlpha:1.0];
        [self.eightButton setAlpha:1.0];
        [self.nineButton setAlpha:1.0];
        self.zeroButton.enabled = YES;
        self.oneButton.enabled = YES;
        self.twoButton.enabled = YES;
        self.threeButton.enabled = YES;
        self.fourButton.enabled = YES;
        self.fiveButton.enabled = YES;
        self.sixButton.enabled = YES;
        self.sevenButton.enabled = YES;
        self.eightButton.enabled = YES;
        self.nineButton.enabled = YES;
        
        [self.AButton setAlpha:0.50];
        [self.BButton setAlpha:0.50];
        [self.CButton setAlpha:0.50];
        [self.DButton setAlpha:0.50];
        [self.EButton setAlpha:0.50];
        [self.FButton setAlpha:0.50];
        self.AButton.enabled = NO;
        self.BButton.enabled = NO;
        self.CButton.enabled = NO;
        self.DButton.enabled = NO;
        self.EButton.enabled = NO;
        self.FButton.enabled = NO;
    }
    
    if ([interface  isEqual: @"hexadecimal"]) {
        [self.zeroButton setAlpha:1.0];
        [self.oneButton setAlpha:1.0];
        [self.twoButton setAlpha:1.0];
        [self.threeButton setAlpha:1.0];
        [self.fourButton setAlpha:1.0];
        [self.fiveButton setAlpha:1.0];
        [self.sixButton setAlpha:1.0];
        [self.sevenButton setAlpha:1.0];
        [self.eightButton setAlpha:1.0];
        [self.nineButton setAlpha:1.0];
        [self.AButton setAlpha:1.0];
        [self.BButton setAlpha:1.0];
        [self.CButton setAlpha:1.0];
        [self.DButton setAlpha:1.0];
        [self.EButton setAlpha:1.0];
        [self.FButton setAlpha:1.0];
        self.zeroButton.enabled = YES;
        self.oneButton.enabled = YES;
        self.twoButton.enabled = YES;
        self.threeButton.enabled = YES;
        self.fourButton.enabled = YES;
        self.fiveButton.enabled = YES;
        self.sixButton.enabled = YES;
        self.sevenButton.enabled = YES;
        self.eightButton.enabled = YES;
        self.nineButton.enabled = YES;
        self.minusButton.enabled = YES;
        self.AButton.enabled = YES;
        self.BButton.enabled = YES;
        self.CButton.enabled = YES;
        self.DButton.enabled = YES;
        self.EButton.enabled = YES;
        self.FButton.enabled = YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
