//
//  UnitConversionPanelController.m
//  HW-1
//
//  Created by Muhammad Naviwala on 9/21/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnitConversionPanelController.h"
#import "MathLibrary.h"

@interface UnitConversionPanelController ()
@property NSArray *measurementTypes;
@property NSArray *measurementUnitLength;
@property NSArray *measurementUnitMass;
@property NSArray *measurementUnitTime;
@property NSArray *measurementUnitTemperature;
@property NSArray *currentMeasurementUnit;
@property NSArray *measurmentIconNamesLight;
@property NSArray *measurmentIconNamesDark;
@property NSInteger currentConvertFromRowNum;
@property NSInteger currentConvertToRowNum;
@end

@implementation UnitConversionPanelController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initialize Data
    self.measurementTypes = @[@"Length", @"Mass", @"Time", @"Temperature"];
    self.measurementUnitLength = @[@"Kilometer", @"Meter", @"Centimeter"];
    self.measurementUnitMass = @[@" Metric Ton", @"Kilogram", @"Gram", @"Milligram"];
    self.measurementUnitTime = @[@"Days", @"Hour", @"Minutes"];
    self.measurementUnitTemperature = @[@"Celsius", @"Fahrenheit", @"Kelvin"];
    self.measurmentIconNamesLight = @[@"lengthIconLight", @"massIconLight", @"timeIconLight", @"temperatureIconLight"];
    self.measurmentIconNamesDark = @[@"lengthIconDark", @"massIconDark", @"timeIconDark", @"temperatureIconDark"];
    
    // Setting the deafult measurement unit
    self.currentMeasurementUnit = self.measurementUnitLength;
    
    // Connect data
    self.pickerMeasurementType.dataSource = self;
    self.pickerMeasurementType.delegate = self;
    
    self.pickerConvertFrom.dataSource = self;
    self.pickerConvertFrom.delegate = self;
    
    self.pickerConvertTo.dataSource = self;
    self.pickerConvertTo.delegate = self;
    
    // To hide the default keyboard
    self.userInput.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if([pickerView isEqual: self.pickerMeasurementType]){
        return 1;
    }
    if([pickerView isEqual: self.pickerConvertFrom] || [pickerView isEqual: self.pickerConvertTo]){
        return 1;
    }
    return 0;
}


// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual: self.pickerMeasurementType]){
        return self.measurementTypes.count;
    }
    if([pickerView isEqual: self.pickerConvertFrom] || [pickerView isEqual: self.pickerConvertTo]){
        return self.currentMeasurementUnit.count;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        tView.textAlignment = NSTextAlignmentCenter;
        
        if([pickerView isEqual: self.pickerMeasurementType]){
            UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(1,2,20,20)];
            dot.image=[UIImage imageNamed:[self.measurmentIconNamesDark objectAtIndex:row]];
            [tView addSubview:dot];
        }
        if([pickerView isEqual: self.pickerConvertFrom] || [pickerView isEqual: self.pickerConvertTo]){
            tView.text = [self.currentMeasurementUnit objectAtIndex:row];
        }
        
        if([pickerView selectedRowInComponent:component] == row){
            tView.backgroundColor = [UIColor darkGrayColor];
            tView.textColor = [UIColor whiteColor];
            
            if([pickerView isEqual: self.pickerMeasurementType]){
                UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(1,2,20,20)];
                dot.image=[UIImage imageNamed:[self.measurmentIconNamesLight objectAtIndex:row]];
                dot.layer.zPosition = 1;
                [tView addSubview:dot];
            }
        }
        
    }
    
    return tView;
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView reloadComponent:component];
    
    if ([pickerView isEqual: self.pickerMeasurementType]) {
        switch (row) {
            case 0:
                self.currentMeasurementUnit = self.measurementUnitLength;
                break;
            case 1:
                self.currentMeasurementUnit = self.measurementUnitMass;
                break;
            case 2:
                self.currentMeasurementUnit = self.measurementUnitTime;
                break;
            case 3:
                self.currentMeasurementUnit = self.measurementUnitTemperature;
                break;
            default:
                break;
        }
        self.currentConvertFromRowNum = self.currentConvertToRowNum = 0;
        [self.pickerConvertFrom selectRow:0 inComponent:0 animated:YES];
        [self.pickerConvertTo selectRow:0 inComponent:0 animated:YES];
        [self.pickerConvertFrom reloadAllComponents];
        [self.pickerConvertTo reloadAllComponents];
    }
    
    if([pickerView isEqual: self.pickerConvertFrom]){
        self.currentConvertFromRowNum = row;
    }
    if([pickerView isEqual: self.pickerConvertTo]){
        self.currentConvertToRowNum = row;
    }
    
    [self startConversion:([self.userInput.text doubleValue])];
    
}

- (void) startConversion: (double)NumberToBeConverted{
    
    double ConvertedNumber = 0;
    NSString *finalNumberToDisplay;
    
#pragma mark Length
    if ([self.currentMeasurementUnit isEqual: self.measurementUnitLength]) {
        if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 0){
            ConvertedNumber =  NumberToBeConverted;
        }if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 1){
            ConvertedNumber = [MathLibrary convertKilometerToMeter:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 2){
            ConvertedNumber = [MathLibrary convertKilometerToCentimeter:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 0){
            ConvertedNumber = [MathLibrary convertMeterToKilometer:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 1){
            ConvertedNumber =  NumberToBeConverted;
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 2){
            ConvertedNumber = [MathLibrary convertMeterToCentimeter:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 0){
            ConvertedNumber = [MathLibrary convertCentimeterToKilometer:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 1){
            ConvertedNumber = [MathLibrary convertCentimeterToMeter:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 2){
            ConvertedNumber =  NumberToBeConverted;
        }
    }
    
#pragma mark Mass
    if ([self.currentMeasurementUnit isEqual: self.measurementUnitMass]) {
        if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 0){
            ConvertedNumber =  NumberToBeConverted;
        }if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 1){
            ConvertedNumber = [MathLibrary convertMetricTonToKilogram:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 2){
            ConvertedNumber = [MathLibrary convertMetricTonToGram:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 3){
            ConvertedNumber = [MathLibrary convertMetricTonToMilligram:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 0){
            ConvertedNumber = [MathLibrary convertKilogramToMetricTon:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 1){
            ConvertedNumber =  NumberToBeConverted;
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 2){
            ConvertedNumber = [MathLibrary convertKilogramToGram:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 3){
            ConvertedNumber = [MathLibrary convertKilogramToMilligram:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 0){
            ConvertedNumber = [MathLibrary convertGramToMetricTon:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 1){
            ConvertedNumber = [MathLibrary convertGramToKiloGram:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 2){
            ConvertedNumber =  NumberToBeConverted;
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 3){
            ConvertedNumber = [MathLibrary convertGramToMilligram:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 3 && self.currentConvertToRowNum == 0){
            ConvertedNumber = [MathLibrary convertMilligramToMetricTon:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 3 && self.currentConvertToRowNum == 1){
            ConvertedNumber = [MathLibrary convertMilligramToKilogram:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 3 && self.currentConvertToRowNum == 2){
            ConvertedNumber = [MathLibrary convertMilligramToGram:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 3 && self.currentConvertToRowNum == 3){
            ConvertedNumber =  NumberToBeConverted;
        }
    }
    
#pragma mark Time
    if ([self.currentMeasurementUnit isEqual: self.measurementUnitTime]) {
        if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 0){
            ConvertedNumber =  NumberToBeConverted;
        }if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 1){
            ConvertedNumber = [MathLibrary convertDaysToHours:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 2){
            ConvertedNumber = [MathLibrary convertDaysToMinutes:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 0){
            ConvertedNumber = [MathLibrary convertHoursToDays:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 1){
            ConvertedNumber =  NumberToBeConverted;
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 2){
            ConvertedNumber = [MathLibrary convertHoursToMinutes:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 0){
            ConvertedNumber = [MathLibrary convertMinutesToDays:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 1){
            ConvertedNumber = [MathLibrary convertMinutesToHours:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 2){
            ConvertedNumber =  NumberToBeConverted;
        }
    }
    
#pragma mark Temperature
    if ([self.currentMeasurementUnit isEqual: self.measurementUnitTemperature]) {
        if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 0){
            ConvertedNumber =  NumberToBeConverted;
        }if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 1){
            ConvertedNumber = [MathLibrary convertCelsiusToFahrenheit:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 0 && self.currentConvertToRowNum == 2){
            ConvertedNumber = [MathLibrary convertCelsiusToKelvin:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 0){
            ConvertedNumber = [MathLibrary convertFahrenheitToCelsius:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 1){
            ConvertedNumber =  NumberToBeConverted;
        }if(self.currentConvertFromRowNum == 1 && self.currentConvertToRowNum == 2){
            ConvertedNumber = [MathLibrary convertFahrenheitToKelvin:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 0){
            ConvertedNumber = [MathLibrary convertKelvinToCelsius:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 1){
            ConvertedNumber = [MathLibrary convertKelvinToFahrenheit:NumberToBeConverted];
        }if(self.currentConvertFromRowNum == 2 && self.currentConvertToRowNum == 2){
            ConvertedNumber =  NumberToBeConverted;
        }
    }
    
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.exponentSymbol = @"e";
    formatter.positiveFormat = @"0.#E+0";
    NSNumber *aDouble = [NSNumber numberWithDouble:ConvertedNumber];
    
    if ([aDouble stringValue].length < 6) {
        finalNumberToDisplay = [aDouble stringValue];
    }else{
        finalNumberToDisplay = [formatter stringFromNumber:aDouble];
    }
    
    self.answerLabel.text = [NSString stringWithFormat:@"%.01f %@ = %.06f %@", NumberToBeConverted, [self.currentMeasurementUnit objectAtIndex:self.currentConvertFromRowNum], ConvertedNumber, [self.currentMeasurementUnit objectAtIndex:self.currentConvertToRowNum]];
    
    self.convertedNumberDisplay.text = [NSString stringWithFormat:@"%@", finalNumberToDisplay];
}


// This only works with the when the default iOS keyboard is used
- (IBAction)userInputChanged:(id)sender {
    [self startConversion:([self.userInput.text doubleValue])];
}

- (IBAction)numPadButtonTapped:(UIButton *)sender {
    BOOL noError = true;
    if ([sender.titleLabel.text  isEqual: @"."] && [[self.userInput.text componentsSeparatedByString:@"."] count]-1 > 0) {
        noError = false;
        [self createAlertBox:@"Error!" : @"You can only have one decimal in the number"];
    }
    if ([sender.titleLabel.text  isEqual: @"-"] && [self.userInput.text length] >= 1) {
        noError = false;
        [self createAlertBox:@"Error!" : @"The negative sign goes at the beginning of the number"];
    }
    
    // All error checks complete at this point
    if (noError) {
        if ([sender.titleLabel.text  isEqual: @"C"]) {
            self.userInput.text = @"";
        }
        if ([sender.titleLabel.text  isEqual: @"⌫"]) {
            if ([self.userInput.text length] > 0) {
                self.userInput.text = [self.userInput.text substringToIndex:[self.userInput.text length] - 1];
            }
        }
        if (![sender.titleLabel.text   isEqual: @"C"] && ![sender.titleLabel.text   isEqual: @"⌫"]){
            self.userInput.text = [self.userInput.text stringByAppendingString:sender.titleLabel.text];
        }
        [self startConversion:([self.userInput.text doubleValue])];
    }
    
}

- (void) createAlertBox :(NSString*)title :(NSString*)message{
    UIAlertView *alertBox = [[UIAlertView alloc] initWithTitle: title message: message delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [alertBox show];
}


@end