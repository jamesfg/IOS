//
//  Team3AddCityViewController.m
//  Team3HW2
//
//  Created by Gabe on 10/5/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "Team3AddCityViewController.h"
#import "Team3AppDelegate.h"
#import "Team3TableViewController.h"


@interface Team3AddCityViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cityNameTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation Team3AddCityViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)addCity {
    
    NSString *url = [@"http://api.openweathermap.org/data/2.5/weather?q=" stringByAppendingString:self.cityNameTextField.text];
    
    Team3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    
    //fetch the result
    NSDictionary *result = [Team3JSONWeather getJSONWithString:url];
    
    //check to see if the result is valid (200 is valid, 404 is invalid)
    if ([[result valueForKey:@"cod"] intValue] == 200){
        
        //creates a new managed object (entity)
        NSManagedObject *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
        
        //set the name of the new entity
        [newItem setValue:[result valueForKey:@"name"] forKey:@"name"];
        
        //NSLog(@"%@", newItem);
        
        //save core data
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }else
        NSLog(@"Invalid City name!");
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if the done button was clicked, add the new city
    if(sender == self.saveButton){
        [self addCity];
    }
}

@end
