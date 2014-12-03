//
//  AllEntriesTableViewController.m
//  SocialJournal
//
//  Created by James Garcia on 10/29/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "AllEntriesTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AllEntriesTableViewCell.h"
#import <Parse/Parse.h>
#import "EntryViewController.h"

@interface AllEntriesTableViewController ()
@property CGSize constraint;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property NSMutableArray *dataFromParse;
@property PFObject *currentEntry;
@property NSMutableArray *usersOfComments;
@property NSMutableArray *comments;
@property NSString *currentUserName;

@property (nonatomic, strong) NSMutableArray *searchResult;

@end

@implementation AllEntriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usersOfComments = [NSMutableArray new];
    self.comments = [NSMutableArray new];
    //broken white [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
    //H [UIColor colorWithRed:(135/255.0) green:(136/255.0) blue:(140/255.0) alpha:1.0];
    //trapped [UIColor colorWithRed:(49/255.0) green:(50/255.0) blue:(51/255.0) alpha:1.0];
    //chinese laque [UIColor colorWithRed:(224/255.0) green:(22/255.0) blue:(22/255.0) alpha:1.0];
    //coulour [UIColor colorWithRed:(6/255.0) green:(20/255.0) blue:(77/255.0) alpha:1.0];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(49/255.0) green:(50/255.0) blue:(51/255.0) alpha:1.0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(340, 285);
    self.spinner.hidesWhenStopped = YES;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    self.spinner.transform = transform;
    [self.view addSubview:self.spinner];
    
    [self.spinner startAnimating];
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    dispatch_async(queue, ^{
        [self fetchDataFromParse];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            [self.tableView reloadData];
            
            self.searchResult = [NSMutableArray arrayWithCapacity:[self.dataFromParse count]];
            
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchDataFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Entries"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"username"];
    self.dataFromParse = [[query findObjects] copy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [self.searchResult count];
    }else{
        return self.dataFromParse.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllEntriesTableViewCell *cell = (AllEntriesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AllEntriesTableCell"];
    if (cell == nil)
    {
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"AllEntriesTableViewCell" owner:self options:nil];
        cell = [xib objectAtIndex:0];
    }
    
    cell.tintColor = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
    
    PFObject *currentCellObject;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        currentCellObject = [self.searchResult objectAtIndex:indexPath.row];
    }else{
        currentCellObject = [self.dataFromParse objectAtIndex:indexPath.row];
    }
    
    
    PFObject *userCellObject = currentCellObject[@"username"];
    cell.postTitle.text = currentCellObject[@"title"];
    cell.postPreview.text = currentCellObject[@"entry"];
    cell.username.text = userCellObject[@"username"];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, YYYY"];
    NSString *datestring = [dateFormatter stringFromDate:[currentCellObject createdAt]];
    
    //NSString *coordinatesString = @"  |  the coordinates go here as well";
    cell.postDate.text = datestring;//[datestring stringByAppendingString:coordinatesString];
    
    cell.postLocation.text = [self getNearestCity:[currentCellObject[@"location"] latitude] :[currentCellObject[@"location"] longitude]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView){
        self.currentEntry = [self.searchResult objectAtIndex:indexPath.row];
    }else{
        self.currentEntry = [self.dataFromParse objectAtIndex:indexPath.row];
    }
    PFObject *userOfComment = self.currentEntry[@"username"];
    self.currentUserName = userOfComment[@"username"];
    [self.spinner startAnimating];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"entry" equalTo:self.currentEntry];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *queryComments, NSError *error) {
        for (PFObject *comment in queryComments) {
            [self.comments addObject:comment];
            [self.usersOfComments addObject:comment[@"user"]];
        }
        [self.spinner stopAnimating];
        [self performSegueWithIdentifier:@"AllEntriesToJournalDetail" sender:self];
    }];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.%K contains[c] %@",@"title", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.dataFromParse filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

-(NSString*)getNearestCity :(double)latitude :(double)longitude{
    __block NSString *result;
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         result = placemark.locality; // Extract the city name
         NSLog(@"Locality1: %@", result);
     }];
    NSLog(@"Locality2: %@", result);

    return result;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AllEntriesToJournalDetail"]) {
        EntryViewController *entryViewController = segue.destinationViewController;
        entryViewController.entry = self.currentEntry;
        entryViewController.pfComments = [self.comments copy];
        entryViewController.usersOfComments = [self.usersOfComments copy];
        entryViewController.username = self.currentUserName;
    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
