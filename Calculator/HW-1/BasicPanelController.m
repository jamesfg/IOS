//
//  BasicPanelController.m
//  HW-1
//
//  Created by Muhammad Naviwala on 9/21/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicPanelController.h"
#import "MathLibrary.h"

@interface BasicPanelController ()
@end

@implementation BasicPanelController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backSpace:(UIButton *)sender {
    if ( [[self.calculationDisplay text] length] > 0 ) {
        [self.calculationDisplay setText: [[self.calculationDisplay text] substringWithRange:NSMakeRange(0, [[self.calculationDisplay text] length] - 1)] ];
    }
}

- (IBAction)numberPressed:(UIButton *)sender {
    NSString *number = sender.currentTitle;
    NSRange isNumberDecimal = [self.calculationDisplay.text rangeOfString:@"."];
    if (self.typingNumber) {
        if ([number isEqualToString:@"."]) {
            // the number inside display label is not decimal
            if (isNumberDecimal.location == NSNotFound) {
                self.calculationDisplay.text = [self.calculationDisplay.text stringByAppendingString:number];
            }
        }else{ //user did not press . button
            self.calculationDisplay.text = [self.calculationDisplay.text stringByAppendingString:number];
        }
    }else{//if user start with . assume the number starts with 0
        if ([number isEqualToString:@"."]) {
            number = @"0.";
        }
        self.calculationDisplay.text = number;
        self.typingNumber = YES;
    }
}

- (IBAction)clearPressed:(UIButton *)sender {
    self.calculationDisplay.text = @" ";
    self.firstNumber = 0;
    self.secondNumber = 0;
    
    
}

- (IBAction)calculationPressed:(id)sender {
    self.typingNumber = NO;
    self.firstNumber = [self.calculationDisplay.text floatValue];
    self.operation = [sender currentTitle];

}

- (IBAction)equalPressed:(UIButton *)sender {
    
    self.typingNumber = NO;
    self.secondNumber = [self.calculationDisplay.text floatValue];
    float result = 0;
    
    if ([self.operation isEqualToString:@"+"]) {
        //result = self.firstNumber + self.secondNumber;
        //ConvertedNumber = [MathLibrary convertKilometerToMeter:NumberToBeConverted];
        result =[MathLibrary addOperand1:self.firstNumber toOperand2:self.secondNumber ];
    }else if([self.operation isEqualToString:@"-"])
    {
        //result = self.firstNumber - self.secondNumber;
        result = [MathLibrary subtractOperand1:self.firstNumber fromOperand2:self.secondNumber];
    }
    else if ([self.operation isEqualToString:@"*"])
    {
        //result = self.firstNumber * self.secondNumber;
        result = [MathLibrary multiplyOperand1:self.firstNumber byOperand2:self.secondNumber];
    }else if([self.operation isEqualToString:@"/"])
    {
        if (self.secondNumber !=0) {
           // result = self.firstNumber / self.secondNumber;
            result = [MathLibrary divdeOperand1:self.firstNumber byOperand2:self.secondNumber];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Input" message:@"The divisor has to be a non-zero number " delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            
            [alert show ];
            
        }
}
    self.calculationDisplay.text = [NSString stringWithFormat:@"%f", result];
}
@end