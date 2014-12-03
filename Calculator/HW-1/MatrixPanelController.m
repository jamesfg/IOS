//
//  MatrixPanelController.m
//  HW-1
//
//  Created by Muhammad Naviwala on 9/21/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatrixPanelController.h"
#import "MathLibrary.h"

@interface MatrixPanelController ()
@property (weak, nonatomic) IBOutlet UITextField *matrix1textField00;
@property (weak, nonatomic) IBOutlet UITextField *matrix1textField01;
@property (weak, nonatomic) IBOutlet UITextField *matrix1textField10;
@property (weak, nonatomic) IBOutlet UITextField *matrix1textField11;

@property (weak, nonatomic) IBOutlet UITextField *matrix2textField00;
@property (weak, nonatomic) IBOutlet UITextField *matrix2textField01;
@property (weak, nonatomic) IBOutlet UITextField *matrix2textField10;
@property (weak, nonatomic) IBOutlet UITextField *matrix2textField11;

@property (weak, nonatomic) IBOutlet UILabel *resultMatrixLabel00;
@property (weak, nonatomic) IBOutlet UILabel *resultMatrixLabel01;
@property (weak, nonatomic) IBOutlet UILabel *resultMatrixLabel10;
@property (weak, nonatomic) IBOutlet UILabel *resultMatrixLabel11;

@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UILabel *equalsLabel;


@property (nonatomic)  UIView* dummyView;


@end

@implementation MatrixPanelController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _matrix1textField00.inputView = _dummyView;
    _matrix1textField01.inputView = _dummyView;
    _matrix1textField10.inputView = _dummyView;
    _matrix1textField11.inputView = _dummyView;
    _matrix2textField00.inputView = _dummyView;
    _matrix2textField01.inputView = _dummyView;
    _matrix2textField10.inputView = _dummyView;
    _matrix2textField11.inputView = _dummyView;
    
    _resultMatrixLabel00.text = @"";
    _resultMatrixLabel01.text = @"";
    _resultMatrixLabel10.text = @"";
    _resultMatrixLabel11.text = @"";
    
    _operationLabel.text = @"";
}

- (IBAction)backpace:(UIButton *)sender {
    NSArray *textFields = @[_matrix1textField00, _matrix1textField01,
                            _matrix1textField10, _matrix1textField11,
                            _matrix2textField00, _matrix2textField01,
                            _matrix2textField10, _matrix2textField11];
    
    for (UITextField *textField in textFields) {
        if ([textField isFirstResponder] && [textField.text length] > 0) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, [textField.text length] - 1 )];
        }
    }
}

- (IBAction)pressKey:(UIButton *)sender {
    NSArray *textFields = @[_matrix1textField00, _matrix1textField01,
                            _matrix1textField10, _matrix1textField11,
                            _matrix2textField00, _matrix2textField01,
                            _matrix2textField10, _matrix2textField11];
    
    for (UITextField *textField in textFields) {
        if ([textField isFirstResponder]) {
            textField.text = [[NSString alloc] initWithFormat:@"%@%@", textField.text, sender.currentTitle];
        }
    }
    
}



- (IBAction)nextFieldFocus:(UIButton *)sender {
    NSArray *textFields = @[_matrix1textField00, _matrix1textField01,
                            _matrix1textField10, _matrix1textField11,
                            _matrix2textField00, _matrix2textField01,
                            _matrix2textField10, _matrix2textField11];
    
    for (int i = 0; i < [textFields count]; i++) {
        if ( [[textFields objectAtIndex:i] isFirstResponder]) {
            
            if (i == [textFields count] - 1) {
                [[textFields objectAtIndex:0] becomeFirstResponder];
                return;
            }
            [[textFields objectAtIndex: i + 1] becomeFirstResponder];
            return;
        }
    }
    
    [[textFields objectAtIndex:0] becomeFirstResponder];
    
}

- (IBAction)clear:(UIButton *)sender {
    _matrix1textField00.text = @"";
    _matrix1textField01.text = @"";
    _matrix1textField10.text = @"";
    _matrix1textField11.text = @"";
    
    _matrix2textField00.text = @"";
    _matrix2textField01.text = @"";
    _matrix2textField10.text = @"";
    _matrix2textField11.text = @"";
    
    _resultMatrixLabel00.text = @"";
    _resultMatrixLabel01.text = @"";
    _resultMatrixLabel10.text = @"";
    _resultMatrixLabel11.text = @"";
    
    _operationLabel.text = @"";
    
}


- (IBAction)setOperation:(UIButton *)sender {
    _operationLabel.text = [sender.currentTitle copy];
}

- (void)setAllBlankFieldsToZero {
    NSArray *textFields = @[_matrix1textField00, _matrix1textField01,
                            _matrix1textField10, _matrix1textField11,
                            _matrix2textField00, _matrix2textField01,
                            _matrix2textField10, _matrix2textField11];
    for (UITextField *textField in textFields ) {
        if ([textField.text length] == 0) {
            textField.text = @"0";
        }
    }
    
}

- (void)setResultMatrixValues:(NSArray *)matrix {
    _resultMatrixLabel00.text = [[NSString alloc] initWithFormat:@"%d", [[matrix objectAtIndex:0] intValue] ];
    _resultMatrixLabel01.text = [[NSString alloc] initWithFormat:@"%d", [[matrix objectAtIndex:1] intValue] ];
    _resultMatrixLabel10.text = [[NSString alloc] initWithFormat:@"%d", [[matrix objectAtIndex:2] intValue] ];
    _resultMatrixLabel11.text = [[NSString alloc] initWithFormat:@"%d", [[matrix objectAtIndex:3] intValue] ];
}


- (IBAction)compute:(UIButton *)sender {
    NSArray *textFields = @[_matrix1textField00, _matrix1textField01,
                            _matrix1textField10, _matrix1textField11,
                            _matrix2textField00, _matrix2textField01,
                            _matrix2textField10, _matrix2textField11];
    for (UITextField *textField in textFields) {
        if ([textField.text length] > 2 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Integer Size"
                                                            message:@"Please use no greater than 2 digit numbers!"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
    }
    NSArray *resultMatrix = @[@0, @0, @0, @0];
    
    [self setAllBlankFieldsToZero];
    NSArray *matrix1 = @[ [[NSNumber alloc] initWithInt:_matrix1textField00.text.intValue],
                          [[NSNumber alloc] initWithInt:_matrix1textField01.text.intValue],
                          [[NSNumber alloc] initWithInt:_matrix1textField10.text.intValue],
                          [[NSNumber alloc] initWithInt:_matrix1textField11.text.intValue] ];
    NSArray *matrix2 = @[ [[NSNumber alloc] initWithInt:_matrix2textField00.text.intValue],
                          [[NSNumber alloc] initWithInt:_matrix2textField01.text.intValue],
                          [[NSNumber alloc] initWithInt:_matrix2textField10.text.intValue],
                          [[NSNumber alloc] initWithInt:_matrix2textField11.text.intValue] ];
    

    if ([_operationLabel.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select an Operation"
                                                        message:@"You must select an operation!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    if ([_operationLabel.text isEqual:@"÷"] && ![MathLibrary is2x2Invertible:matrix2]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Division Error"
                                                        message:@"The second matrix must be invertible!"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }

    if ([_operationLabel.text isEqual:@"+"]) {
        resultMatrix = [MathLibrary add2x2Matrix:matrix1 withOperand2:matrix2];
    }else if ([_operationLabel.text isEqual:@"-"]) {
        resultMatrix = [MathLibrary subtract2x2Matrix:matrix1 withOperand2:matrix2];
    }else if ([_operationLabel.text isEqual:@"*"]) {
        resultMatrix = [MathLibrary multiply2x2Matrix:matrix1 withOperand2:matrix2];
    }else if ([_operationLabel.text isEqual:@"÷"]) {
        resultMatrix = [MathLibrary divide2x2Matrix:matrix1 withOperand2:matrix2];
    }

    [self setResultMatrixValues:resultMatrix];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end