//
//  ProfileViewController.m
//  SocialJournal
//
//  Created by James Garcia on 11/12/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "ProfileViewController.h"
#import "AllEntriesTableViewCell.h"
#import <Parse/Parse.h>
#import "EntryViewController.h"

@interface ProfileViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalHeartsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *dataFromParse;
@property PFObject *currentEntry;
@property NSMutableArray *usersOfComments;
@property NSMutableArray *comments;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.comments = [NSMutableArray new];
    self.usersOfComments = [NSMutableArray new];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(49/255.0) green:(50/255.0) blue:(51/255.0) alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:(49/255.0) green:(50/255.0) blue:(51/255.0) alpha:1.0]}];
    self.navigationController.navigationBar.translucent = YES;
    // Do any additional setup after loading the view.
    
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
        });
    });
    self.profileNameLabel.text = [PFUser currentUser].username;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchDataFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Entries"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"username" equalTo:[PFUser currentUser]];
    self.dataFromParse = [[query findObjects] copy];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    
    return self.dataFromParse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllEntriesTableViewCell *cell = (AllEntriesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AllEntriesTableCell"];
    if (cell == nil)
    {
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"AllEntriesTableViewCell" owner:self options:nil];
        cell = [xib objectAtIndex:0];
    }
    
    cell.tintColor = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
    
    PFObject *currentCellObject = [self.dataFromParse objectAtIndex:indexPath.row];
    cell.postTitle.text = currentCellObject[@"title"];
    cell.postPreview.text = currentCellObject[@"entry"];
    cell.username.text = [PFUser currentUser].username;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, YYYY"];
    NSString *datestring = [dateFormatter stringFromDate:[currentCellObject createdAt]];
    NSString *coordinatesString = @"  |  the coordinates go here as well";
    cell.postDate.text = [datestring stringByAppendingString:coordinatesString];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return @"Posts";
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 15)];
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(0 ,0,tableView.frame.size.width,20)];
    
    [headerView setBackgroundColor:[UIColor colorWithRed:(49/255.0) green:(50/255.0) blue:(51/255.0) alpha:1.0]];
    tempLabel.backgroundColor= [UIColor clearColor];
    tempLabel.textColor = [UIColor colorWithRed:(224/255.0) green:(22/255.0) blue:(22/255.0) alpha:1.0];
    tempLabel.font = [UIFont fontWithName:@"HelveticaNew" size:15];
    tempLabel.font = [UIFont boldSystemFontOfSize:15];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    if (section == 0) {
        tempLabel.text=@"Posts";
    }
    
    [headerView addSubview:tempLabel];
    
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentEntry = [self.dataFromParse objectAtIndex:indexPath.row];
    
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
        [self performSegueWithIdentifier:@"ProfileToPost" sender:self];
    }];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ProfileToPost"]) {
        EntryViewController *entryViewController = segue.destinationViewController;
        entryViewController.entry = self.currentEntry;
        entryViewController.username = [PFUser currentUser].username;
        entryViewController.pfComments = [self.comments copy];
        entryViewController.usersOfComments = [self.usersOfComments copy];
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
