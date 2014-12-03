//
//  ViewController.m
//  HW-1
//
//  Created by Muhammad Naviwala on 9/21/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property NSArray *controllerNames;
@property CustomUIViewController* currentViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initalize data
    self.controllerNames = @[@"BasicPanelController", @"ScientificPanelController", @"HexPanelController", @"MatrixPanelController", @"UnitConversionPanelController"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    CustomUIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = self.constrainedView.bounds;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (CustomUIViewController *)viewControllerAtIndex:(NSUInteger)index{
    if (([self.controllerNames count] == 0) || (index >= [self.controllerNames count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    CustomUIViewController *pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:[self.controllerNames objectAtIndex:index]];
    pageViewController.pageIndex = index;
    
    return pageViewController;
}

#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((CustomUIViewController*) viewController).pageIndex;
    self.currentViewController = (CustomUIViewController*) viewController;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((CustomUIViewController*) viewController).pageIndex;
    self.currentViewController = (CustomUIViewController*) viewController;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.controllerNames count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return [self.controllerNames count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}



@end
