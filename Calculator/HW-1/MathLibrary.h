//
//  MathLibrary.h
//  HW-1
//
//  Created by Muhammad Naviwala on 9/21/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "math.h"

@interface MathLibrary : NSObject

+ (float)addOperand1:(float)firstFloat toOperand2:(float)secondFloat;
+ (float)subtractOperand1:(float)firstFloat fromOperand2:(float)secondFloat;
+ (float)multiplyOperand1:(float)firstFloat byOperand2:(float)secondFloat;
+ (float)divdeOperand1:(float)firstFloat byOperand2:(float)secondFloat;


+ (float)sineUsingDegrees:(float)degrees;
+ (float)sineUsingRadians:(float)radians;
+ (float)log:(float)value;
+ (float)modulusOperand1:(float)firstFloat withOperand2:(float)secondFloat;
+ (float)squareRoot:(float)value;
+ (float)exponetBase:(float)base raiseTo:(float)exponet;
+ (int)factorial:(int)value;

+ (BOOL)is2x2Invertible:(NSArray *)matrix;

+ (NSArray *)add2x2Matrix:(NSArray *)operand1 withOperand2:(NSArray *)operand2;
+ (NSArray *)subtract2x2Matrix:(NSArray *)operand1 withOperand2:(NSArray *)operand2;
+ (NSArray *)multiply2x2Matrix:(NSArray *)operand1 withOperand2:(NSArray *)operand2;
+ (NSArray *)divide2x2Matrix:(NSArray *)operand1 withOperand2:(NSArray *)operand2;




#pragma mark - Length
+ (double)convertKilometerToMeter:(double)numberToConvert;
+ (double)convertKilometerToCentimeter:(double)numberToConvert;
+ (double)convertMeterToKilometer:(double)numberToConvert;
+ (double)convertMeterToCentimeter:(double)numberToConvert;
+ (double)convertCentimeterToKilometer:(double)numberToConvert;
+ (double)convertCentimeterToMeter:(double)numberToConvert;

#pragma mark - Mass
+ (double)convertMetricTonToKilogram:(double)numberToConvert;
+ (double)convertMetricTonToGram:(double)numberToConvert;
+ (double)convertMetricTonToMilligram:(double)numberToConvert;
+ (double)convertKilogramToMetricTon:(double)numberToConvert;
+ (double)convertKilogramToGram:(double)numberToConvert;
+ (double)convertKilogramToMilligram:(double)numberToConvert;
+ (double)convertGramToMetricTon:(double)numberToConvert;
+ (double)convertGramToKiloGram:(double)numberToConvert;
+ (double)convertGramToMilligram:(double)numberToConvert;
+ (double)convertMilligramToMetricTon:(double)numberToConvert;
+ (double)convertMilligramToKilogram:(double)numberToConvert;
+ (double)convertMilligramToGram:(double)numberToConvert;

#pragma mark - Time
+ (double)convertDaysToHours:(double)numberToConvert;
+ (double)convertDaysToMinutes:(double)numberToConvert;
+ (double)convertHoursToDays:(double)numberToConvert;
+ (double)convertHoursToMinutes:(double)numberToConvert;
+ (double)convertMinutesToDays:(double)numberToConvert;
+ (double)convertMinutesToHours:(double)numberToConvert;

#pragma mark - Temperature
+ (double)convertCelsiusToFahrenheit:(double)numberToConvert;
+ (double)convertCelsiusToKelvin:(double)numberToConvert;
+ (double)convertFahrenheitToCelsius:(double)numberToConvert;
+ (double)convertFahrenheitToKelvin:(double)numberToConvert;
+ (double)convertKelvinToCelsius:(double)numberToConvert;
+ (double)convertKelvinToFahrenheit:(double)numberToConvert;

#pragma mark - Hex
+ (NSString *)binaryToDecimal:(NSString *)textField;
+ (NSString *)binaryToHex:(NSString *)textField;
+ (NSString *)decimalToBinary:(NSString *)textField;
+ (NSString *)decimalToHex:(NSString *)textField;
+ (NSString *)hexToBinary:(NSString *)textField;
+ (NSString *)hexToDecimal:(NSString *)textField;
@end