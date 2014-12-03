//
//  DetailViewController.m
//  SocialJournal
//
//  Created by Gabe on 10/17/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "DetailViewController.h"
#import <Parse/Parse.h>

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *journalEntryTextView;
@property (weak, nonatomic) IBOutlet UIView *whiteBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *labelDayName;
@property (weak, nonatomic) IBOutlet UILabel *labelDay;
@property (weak, nonatomic) IBOutlet UILabel *labelMonth;
@property (weak, nonatomic) IBOutlet UILabel *labelYear;

@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"lat: %f lon: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //NSLog(@"%@", [locations lastObject]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.whiteBackgroundView.layer.masksToBounds = NO;
    self.whiteBackgroundView.layer.shadowOffset = CGSizeMake(-15, 0);
    self.whiteBackgroundView.layer.shadowRadius = 5;
    self.whiteBackgroundView.layer.shadowOpacity = 0.7;
    [self assignDate];
    
    [self configureView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager setDelegate:self];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    NSLog(@"Device Location: %@", [self deviceLocation]);
}

- (void) assignDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"EEEE"];
    self.labelDayName.text = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd"];
    self.labelDay.text = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"MMMM"];
    self.labelMonth.text = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"YYYY"];
    self.labelYear.text = [dateFormatter stringFromDate:[NSDate date]];
}

/*
 * Method: replaceWordInString(text:removed:replacement)
 * pass text, the word to be removed, and the word to be replaced to this method
 * it will return the text with the removed word replaced with the desired wored
 */
-(NSString*) replaceWordInString: (NSString*)text : (NSString*)removed : (NSString*)replacement{
    return [text stringByReplacingOccurrencesOfString:removed withString:replacement];
}

/*
 * Method: getTagsFromText(text)
 * pass text to this method and it will return an array of hashtags
 * a hashtag is any of the following:
 * #yes #YESyesyes # no #n o #YesYes
 * no whitespace in a hashtag
 */
- (NSMutableArray*) getTagsFromText: (NSString*)text{
    //initialize the arrays
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *wordArray = [text componentsSeparatedByString:@" "];
    
    //go through the text to find hashtags
    for(int i = 0; i < wordArray.count; i++){
        //if the first letter of a word starts with a hashtag
        if([[wordArray[i] substringFromIndex:0] containsString:@"#"]){
            NSString *temp = [wordArray objectAtIndex:i];
            //more in depth hashtag checking to make sure its a valid format
            //could potentially change to regex if someone wants to get fancy
            if(temp.length > 1 &&
               ![[temp substringFromIndex:1] containsString:@"#"]){
                
                //add the correct hashtag to the result array
                [result addObject:temp];
                //NSLog(@"%@", result);
            }
        }
    }
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonClicked:(id)sender {
    
    NSMutableArray *entryTags = [self getTagsFromText:self.journalEntryTextView.text];
    NSMutableArray *titleTags = [self getTagsFromText:self.titleText.text];
    NSArray *tags = [entryTags arrayByAddingObjectsFromArray:titleTags];
    NSLog(@"%@", tags);
    
    PFObject *eachEntry = [PFObject objectWithClassName:@"Entries"];
    eachEntry[@"title"] = self.titleText.text;
    eachEntry[@"entry"] = self.journalEntryTextView.text;
    eachEntry[@"username"] = [PFUser currentUser];
    eachEntry[@"location"] = [PFGeoPoint geoPointWithLatitude:self.locationManager.location.coordinate.latitude
                                                    longitude:self.locationManager.location.coordinate.longitude];
    [eachEntry saveEventually];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your journal entry has been saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}




@end
