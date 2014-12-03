//
//  Team3DetailViewController.m
//  Team3HW2
//
//  Created by Gabe on 10/5/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "Team3DetailViewController.h"

@interface Team3DetailViewController ()

//current weather info labels
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentWeatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

//detail info labels
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;

//hourly info labels
@property (weak, nonatomic) IBOutlet UILabel *firstTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixthTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *seventhTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eigthTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixthTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *seventhTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *eigthTempLabel;

//weekly info labels
@property (weak, nonatomic) IBOutlet UILabel *mondayLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayMinTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayMaxTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *tuesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayMinTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayMaxTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayMinTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayMaxTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayMinTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayMaxTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *fridayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayMinTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayMaxTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *saturdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayMinTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayMaxTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *sundayLabel;
@property (weak, nonatomic) IBOutlet UILabel *sundayMinTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *sundayMaxTempLabel;

@property (strong, nonatomic) NSString *unitSettings;
@property (strong, nonatomic) NSString *unitShort;

@end

@implementation Team3DetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(700, 80)];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.unitSettings = [userDefaults stringForKey:@"units"];
    [self fetchData];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchData
{
    self.unitShort = [Team3JSONWeather getUnitAbreviation:self.unitSettings];
    [self setupDetailInformation];
    [self setupHourlyForecast];
    [self setupWeeklyForecast];
}

-(void)setupDetailInformation
{
    self.weatherData = [Team3JSONWeather getJSONWithString: [Team3JSONWeather buildUrl:@"weather" :self.currentCity :self.unitSettings]];
    

    //did it this way because we still need the spaces between the words, and stripJson removes all spaces;
    NSString *string = [NSString stringWithFormat:@"%@", [self.weatherData valueForKeyPath:@"weather.description"]];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    string = [string capitalizedString];
    
    NSString *iconString = [NSString stringWithFormat:@"%@", [self.weatherData valueForKeyPath:@"weather.icon"]];
    iconString = [iconString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    iconString = [iconString stringByReplacingOccurrencesOfString:@")" withString:@""];
    iconString = [iconString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    iconString = [iconString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    iconString = [iconString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self.weatherImage.image = [Team3JSONWeather assignWeatherIcon:iconString];
    self.backgroundImage.image = [Team3JSONWeather assignBackgroundImage:iconString];
    self.navigationItem.title = [self.weatherData valueForKey:@"name"];
    self.currentWeatherLabel.text = string;
    self.currentTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[self.weatherData valueForKeyPath:@"main.temp"] floatValue], self.unitShort];
    self.minTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[self.weatherData valueForKeyPath:@"main.temp_min"] floatValue], self.unitShort];
    self.maxTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[self.weatherData valueForKeyPath:@"main.temp_max"] floatValue], self.unitShort];
    self.humidityLabel.text = [NSString stringWithFormat:@"%.f", [[self.weatherData valueForKeyPath:@"main.humidity"] floatValue]];
    self.pressureLabel.text = [NSString stringWithFormat:@"%.f", [[self.weatherData valueForKeyPath:@"main.pressure"] floatValue]];
    
}

-(void)setupHourlyForecast
{
    self.hourlyData = [Team3JSONWeather getJSONWithString: [Team3JSONWeather buildUrl:@"forecast" :self.currentCity :self.unitSettings]];
    self.firstTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.hourlyData valueForKeyPath:@"list.main.temp"] objectAtIndex:0] floatValue], self.unitShort];
    self.secondTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.hourlyData valueForKeyPath:@"list.main.temp"] objectAtIndex:1] floatValue], self.unitShort];
    self.thirdTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.hourlyData valueForKeyPath:@"list.main.temp"] objectAtIndex:2] floatValue], self.unitShort];
    self.fourthTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.hourlyData valueForKeyPath:@"list.main.temp"] objectAtIndex:3] floatValue], self.unitShort];
    self.fifthTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.hourlyData valueForKeyPath:@"list.main.temp"] objectAtIndex:4] floatValue], self.unitShort];
    self.sixthTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.hourlyData valueForKeyPath:@"list.main.temp"] objectAtIndex:5] floatValue], self.unitShort];
    self.seventhTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.hourlyData valueForKeyPath:@"list.main.temp"] objectAtIndex:6] floatValue], self.unitShort];
    self.eigthTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.hourlyData valueForKeyPath:@"list.main.temp"] objectAtIndex:7] floatValue], self.unitShort];
    
    self.firstTimeLabel.text = [self convertTheDate:[[self.hourlyData valueForKeyPath:@"list.dt"] objectAtIndex:0]];
    self.secondTimeLabel.text = [self convertTheDate:[[self.hourlyData valueForKeyPath:@"list.dt"] objectAtIndex:1]];
    self.thirdTimeLabel.text = [self convertTheDate:[[self.hourlyData valueForKeyPath:@"list.dt"] objectAtIndex:2]];
    self.fourthTimeLabel.text = [self convertTheDate:[[self.hourlyData valueForKeyPath:@"list.dt"] objectAtIndex:3]];
    self.fifthTimeLabel.text = [self convertTheDate:[[self.hourlyData valueForKeyPath:@"list.dt"] objectAtIndex:4]];
    self.sixthTimeLabel.text = [self convertTheDate:[[self.hourlyData valueForKeyPath:@"list.dt"] objectAtIndex:5]];
    self.seventhTimeLabel.text = [self convertTheDate:[[self.hourlyData valueForKeyPath:@"list.dt"] objectAtIndex:6]];
    self.eigthTimeLabel.text = [self convertTheDate:[[self.hourlyData valueForKeyPath:@"list.dt"] objectAtIndex:7]];
}

- (NSString *) convertTheDate:(NSString *) epochTime
{
    NSTimeInterval seconds = [epochTime doubleValue];
    
    NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    return [dateFormatter stringFromDate:epochNSDate];
}

-(void)setupWeeklyForecast
{
    self.weeklyData = [Team3JSONWeather getJSONWithString: [Team3JSONWeather buildUrl:@"forecast/daily" :self.currentCity :self.unitSettings]];

    //set the max temperature labels
    self.mondayMaxTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.max"] objectAtIndex:0] floatValue], self.unitShort];
    self.tuesdayMaxTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.max"] objectAtIndex:1] floatValue], self.unitShort];
    self.wednesdayMaxTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.max"] objectAtIndex:2] floatValue], self.unitShort];
    self.thursdayMaxTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.max"] objectAtIndex:3] floatValue], self.unitShort];
    self.fridayMaxTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.max"] objectAtIndex:4] floatValue], self.unitShort];
    self.saturdayMaxTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.max"] objectAtIndex:5] floatValue], self.unitShort];
    self.sundayMaxTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.max"] objectAtIndex:6] floatValue], self.unitShort];
    
    //set the min temperature labels
    self.mondayMinTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.min"] objectAtIndex:0] floatValue], self.unitShort];
    self.tuesdayMinTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.min"] objectAtIndex:1] floatValue], self.unitShort];
    self.wednesdayMinTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.min"] objectAtIndex:2] floatValue], self.unitShort];
    self.thursdayMinTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.min"] objectAtIndex:3] floatValue], self.unitShort];
    self.fridayMinTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.min"] objectAtIndex:4] floatValue], self.unitShort];
    self.saturdayMinTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.min"] objectAtIndex:5] floatValue], self.unitShort];
    self.sundayMinTempLabel.text = [NSString stringWithFormat:@"%.fº%@", [[[self.weeklyData valueForKeyPath:@"list.temp.min"] objectAtIndex:6] floatValue], self.unitShort];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
