//
//  Team3SettingsViewController.m
//  Team3HW2
//
//  Created by Xiaolu Zhang on 10/5/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "Team3SettingsViewController.h"

@interface Team3SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitsSegmentedControl;
@end


@implementation Team3SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.unitsSegmentedControl.selectedSegmentIndex = ([[userDefaults stringForKey:@"units"] isEqualToString:@"metric"]) ? 0 : 1;
}

- (IBAction)unitsChange:(UISegmentedControl *)sender {
    sender.selectedSegmentIndex == 0 ? [self saveToUserDefaults:@"metric"] : [self saveToUserDefaults:@"imperial"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)saveToUserDefaults:(NSString*)myString
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:myString forKey:@"units"];
        [standardUserDefaults synchronize];
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

@end
