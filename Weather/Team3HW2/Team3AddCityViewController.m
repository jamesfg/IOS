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
        
        // check if duplicate exists
        if(![self checkForDuplicateCity]){
        
            //creates a new managed object (entity)
            NSManagedObject *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
            
            //set the name of the new entity
            [newItem setValue:[result valueForKey:@"name"] forKey:@"name"];
            
            //save core data
            NSError *error = nil;
            if (![context save:&error]) {
                
            }
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"You can't have duplicate city names" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[result valueForKeyPath:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (bool) checkForDuplicateCity
{
    NSMutableArray *newCities = [[NSMutableArray alloc] init];
    bool toReturn = false;
    
    Team3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"City" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        
    } else {
        for (NSManagedObject *object in objects) {
            if ([newCities containsObject:[object valueForKey:@"name"]]) {
                toReturn = true;
                
            }
            else{
                [newCities addObject: [object valueForKey:@"name"] ];
            }
        }
    }
    
    return toReturn;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if the done button was clicked, add the new city
    if(sender == self.saveButton){
        [self addCity];
    }
}

@end
