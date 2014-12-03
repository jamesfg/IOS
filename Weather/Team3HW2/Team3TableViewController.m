//
//  Team3TableViewController.m
//  Team3HW2
//
//  Created by Gabe on 10/5/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "Team3TableViewController.h"
#import "Team3AppDelegate.h"
#import "Team3DetailViewController.h"

@interface Team3TableViewController ()
@property (strong, nonatomic) NSArray *cities;
@property NSDictionary* weatherData;
@property NSString *currentCity;
@property (strong, nonatomic) NSString *unitSettings;
@property (strong, nonatomic) NSString *unitShort;
@end

@implementation Team3TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)deleteCityFromCoreData:(NSString *)cityNameToDelete{
    Team3AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"City"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", cityNameToDelete];
    [request setPredicate:predicate];
    
    NSError *error = nil;

    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (!error && result.count > 0) {
        for(NSManagedObject *managedObject in result){
            [context deleteObject:managedObject];
        }
        
        //Save context to write to store
        [context save:nil];
    }
}

- (void)fetchCitiesFromCoreData{
    
    NSMutableArray *newCities = [[NSMutableArray alloc] init];
    
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
            [newCities addObject: [object valueForKey:@"name"] ];
        }

    }
    self.cities = [newCities copy];
    
}

- (void)viewDidLoad
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.unitSettings = [userDefaults stringForKey:@"units"];
    [self fetchCitiesFromCoreData];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"gear.png"] style: UIBarButtonItemStyleBordered target:self action:@selector(showSettings)];
    self.navigationItem.leftBarButtonItem = settingsButton;
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background15.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [super viewDidLoad];
}

- (void)showSettings {
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.unitSettings = [userDefaults stringForKey:@"units"];
    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.cities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
    
    self.weatherData = [Team3JSONWeather getJSONWithString: [Team3JSONWeather buildUrl:@"weather" :[self.cities objectAtIndex:indexPath.row] :self.unitSettings]];
    
    //setup json for image
    NSString *conditionUrl = [NSString stringWithFormat:@"%@",[self.weatherData valueForKeyPath:@"weather.icon"]];
    conditionUrl = [Team3JSONWeather stripJson:conditionUrl];
    
    float temp = [[self.weatherData valueForKeyPath:@"main.temp"] floatValue];
    NSString* roundedTemp = [NSString stringWithFormat:@"%.f", temp];
    
    // Configure the cell...
    self.unitShort = [Team3JSONWeather getUnitAbreviation:self.unitSettings];
    // cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"Background5.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] ];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [Team3JSONWeather assignBackgroundImage:conditionUrl] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] ];
    cell.textLabel.numberOfLines = 0;
    [cell.imageView setImage:[Team3JSONWeather assignWeatherIcon:conditionUrl]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@º%@ \n%@", roundedTemp, self.unitShort , [self.weatherData valueForKeyPath:@"name"]];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView beginUpdates];
        [self deleteCityFromCoreData: [self.cities objectAtIndex:indexPath.row] ];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self fetchCitiesFromCoreData];
        [tableView endUpdates];
        [self.tableView reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [[segue identifier] isEqualToString:@"detailCity"]){
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        self.weatherData = [Team3JSONWeather getJSONWithString: [Team3JSONWeather buildUrl:@"weather" :[self.cities objectAtIndex:path.row] :@"imperial"]];
        self.currentCity = [self.weatherData valueForKeyPath:@"name"];
        
        Team3DetailViewController *next = [segue destinationViewController];
        next.currentCity = self.currentCity;
    }
}

- (IBAction)unwindToTable:(UIStoryboardSegue *)segue{
    [self fetchCitiesFromCoreData];
    [self.tableView reloadData];
}

@end
