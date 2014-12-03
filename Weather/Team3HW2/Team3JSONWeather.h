//
//  Team3JSONWeather.h
//  Team3HW2
//
//  Created by Gabe on 10/2/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Team3JSONWeather : NSObject

@property (nonatomic,strong) NSString *tempUnit;

+ (NSDictionary *)getJSONWithString:(NSString *)url;
+ (NSString *)stripJson:(NSString *)jsonString;
+ (NSString *)buildUrl:(NSString*)forecastType :(NSString *)city :(NSString *)unit;
+ (UIImage *)assignWeatherIcon:(NSString *) iconName;
+ (UIImage *)assignBackgroundImage:(NSString *) iconName;
+ (NSString *)getUnitAbreviation:(NSString *)unitType; 

@end
