//
//  EntryViewController.m
//  SocialJournal
//
//  Created by James Garcia on 11/9/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "EntryViewController.h"
#import "CommentTableViewCell.h"

@interface EntryViewController ()
@property (weak, nonatomic) IBOutlet UIView *whiteBackgroundView;
@property UITextField *commentAlertTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *tagsTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelDayName;
@property (weak, nonatomic) IBOutlet UILabel *labelDay;
@property (weak, nonatomic) IBOutlet UILabel *labelMonth;
@property (weak, nonatomic) IBOutlet UILabel *labelYear;

@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileNameLabel.text = self.username;
    self.whiteBackgroundView.layer.masksToBounds = NO;
    self.whiteBackgroundView.layer.shadowOffset = CGSizeMake(-15, 0);
    self.whiteBackgroundView.layer.shadowRadius = 5;
    self.whiteBackgroundView.layer.shadowOpacity = 0.7;
    self.titleTextField.text = self.entry[@"title"];
    self.contentTextField.text = self.entry[@"entry"];
    [self assignDate];
}

- (void) assignDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"EEEE"];
    self.labelDayName.text = [dateFormatter stringFromDate:[self.entry createdAt]];
    
    [dateFormatter setDateFormat:@"dd"];
    self.labelDay.text = [dateFormatter stringFromDate:[self.entry createdAt]];
    
    [dateFormatter setDateFormat:@"MMMM"];
    self.labelMonth.text = [dateFormatter stringFromDate:[self.entry createdAt]];
    
    [dateFormatter setDateFormat:@"YYYY"];
    self.labelYear.text = [dateFormatter stringFromDate:[self.entry createdAt]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)heartButtonClicked:(UIButton *)sender {
    if ([[sender.imageView accessibilityIdentifier] isEqualToString:@"HeartWhite"]) {
        UIImageView *newImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HeartRed"]];
        [sender setImage:newImageView.image forState:UIControlStateNormal];
    }else{
        UIImageView *newImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HeartWhite"]];
        [sender setImage:newImageView.image forState:UIControlStateNormal];
    }
}

- (IBAction)commentButtonClicked:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Submit new comment" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.commentAlertTextField = [alert textFieldAtIndex:0];
    self.commentAlertTextField.placeholder = @"Enter your comment...";
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        PFObject *newComment = [PFObject objectWithClassName:@"Comments"];
        newComment[@"content"] = self.commentAlertTextField.text;
        newComment[@"user"] = [PFUser currentUser];
        newComment[@"entry"] = self.entry;
        [newComment saveEventually];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pfComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
    if (cell == nil)
    {
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
        cell = [xib objectAtIndex:0];
    }
    
    cell.tintColor = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1.0];
    
    PFObject *currentCellObject = [self.pfComments objectAtIndex:indexPath.row];
    PFObject *userNameForComment = [self.usersOfComments objectAtIndex:indexPath.row];
    cell.userName.text = userNameForComment[@"username"];
    cell.commentText.text = currentCellObject[@"content"];
    cell.dateAndCoordinates.text = @"Coordinates go here";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Comment clicked!");
}

- (IBAction)showCommentsButtonClicked:(UIButton *)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    if (sender.frame.origin.y > 700) {
        sender.frame = CGRectMake(147, 506, 556, 44);
        [sender setTitle:@"Hide Comments" forState:UIControlStateNormal];
        self.tableView.frame = CGRectMake(147, 548, 556, 220);
    }else{
        sender.frame = CGRectMake(147, 724, 556, 44);
        [sender setTitle:@"Show Comments" forState:UIControlStateNormal];
        self.tableView.frame = CGRectMake(147, 771, 556, 220);
    }
    
    [UIView commitAnimations];
}


@end
