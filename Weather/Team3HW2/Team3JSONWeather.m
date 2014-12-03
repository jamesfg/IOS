//
//  Team3JSONWeather.m
//  Team3HW2
//
//  Created by Gabe on 10/2/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "Team3JSONWeather.h"

@implementation Team3JSONWeather

+ (NSDictionary *)getJSONWithString:(NSString *)url {
    
    NSString* escapedUrlString =  [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *requestURL = [ NSURL URLWithString:[NSString stringWithUTF8String:[escapedUrlString UTF8String]] ];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if ((long)[urlResponse statusCode] != 200 && (long)[error code] != 0 ) {
        NSLog(@"HTTP Response Code: %ld, Error Code: %ld", (long)[urlResponse statusCode], (long)[error code]);
    }
    
    NSError *e = nil;
    NSMutableDictionary *resultList = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:&e];
    
    return [resultList copy];
}
- (void)changedUnitsForUrl:(NSString *)units {
   
    if ([units  isEqual: @"metric"]) {
        
        self.tempUnit = @"metric";
    }
    else
    {
        self.tempUnit = @"imperial";
    }
    
}

+ (NSString *)stripJson:(NSString *)jsonString {
    
    NSString *string = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return string;
}

+ (NSString *)buildUrl:(NSString*)forecastType :(NSString *)city :(NSString *)unit {
    //               Current,  3-Hour , 7 Day
    //forecastType = weather, forecast, forecast/daily
    //unit = imperial, metric
    
    NSString *sevenDay = @"";
    if ([forecastType  isEqual: @"forecast/daily"]) {
        sevenDay = @"&cnt=7";
    }
    NSString *rootUrl = @"http://api.openweathermap.org/data/2.5/";
    NSString *url = [NSString stringWithFormat:@"%@%@?q=%@&units=%@%@",rootUrl, forecastType, city, unit, sevenDay];
    
    return url;
}

+(UIImage *)assignWeatherIcon:(NSString *) iconName{
    
    NSString *imageNameToReturn = @"Cloudy.png";  // default
    
    if ([iconName isEqual: @"01d"] || [iconName isEqual: @"01n"]) {
        imageNameToReturn = @"Sunny.png";
    }
    if ([iconName isEqual: @"02d"] || [iconName isEqual: @"02n"]) {
        imageNameToReturn = @"Mostly Cloudy.png";
    }
    if ([iconName isEqual: @"03d"] || [iconName isEqual: @"03n"]) {
        imageNameToReturn = @"Cloudy.png";
    }
    if ([iconName isEqual: @"04d"] || [iconName isEqual: @"04n"]) {
        imageNameToReturn = @"Cloudy.png";
    }
    if ([iconName isEqual: @"09d"] || [iconName isEqual: @"09n"]) {
        imageNameToReturn = @"Slight Drizzle.png";
    }
    if ([iconName isEqual: @"10d"] || [iconName isEqual: @"10n"]) {
        imageNameToReturn = @"Drizzle.png";
    }
    if ([iconName isEqual: @"11d"] || [iconName isEqual: @"11n"]) {
        imageNameToReturn = @"Thunderstorms.png";
    }
    if ([iconName isEqual: @"13d"] || [iconName isEqual: @"13n"]) {
        imageNameToReturn = @"Snow.png";
    }
    if ([iconName isEqual: @"50d"] || [iconName isEqual: @"50n"]) {
        imageNameToReturn = @"Haze.png";
    }
    
    return [UIImage imageNamed:imageNameToReturn];
}

+(UIImage *)assignBackgroundImage:(NSString *) iconName{
    
    NSString *imageNameToReturn = @"Background5.png";  // default
    
    if ([iconName isEqual: @"01d"] || [iconName isEqual: @"01n"]) {
        imageNameToReturn = @"Background2.png";
    }
    if ([iconName isEqual: @"02d"] || [iconName isEqual: @"02n"]) {
        imageNameToReturn = @"Background6.png";
    }
    if ([iconName isEqual: @"03d"] || [iconName isEqual: @"03n"]) {
        imageNameToReturn = @"Background3.png";
    }
    if ([iconName isEqual: @"04d"] || [iconName isEqual: @"04n"]) {
        imageNameToReturn = @"Background10.png";
    }
    if ([iconName isEqual: @"09d"] || [iconName isEqual: @"09n"]) {
        imageNameToReturn = @"Background1.png";
    }
    if ([iconName isEqual: @"10d"] || [iconName isEqual: @"10n"]) {
        imageNameToReturn = @"Background12.png";
    }
    if ([iconName isEqual: @"11d"] || [iconName isEqual: @"11n"]) {
        imageNameToReturn = @"Background5.png";
    }
    if ([iconName isEqual: @"13d"] || [iconName isEqual: @"13n"]) {
        imageNameToReturn = @"Background7.png";
    }
    if ([iconName isEqual: @"50d"] || [iconName isEqual: @"50n"]) {
        imageNameToReturn = @"Background11.png";
    }
    
    return [UIImage imageNamed:imageNameToReturn];
}

+(NSString *)getUnitAbreviation:(NSString *)unitType {

    if ([unitType isEqual:@"metric"]) {
        return @"C";
    }
    if ([unitType isEqual:@"imperial"]) {
        return @"F";
    }
    return @"";
}

@end
