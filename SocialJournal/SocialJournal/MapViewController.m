//
//  MapViewController.m
//  SocialJournal
//
//  Created by Matt Phillips on 11/12/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLPlacemark *placmark;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getNearestCity:29.76 :-95.36];
    [self showMapLocation:29.76 :-95.36];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) showMapLocation:(double)latitude :(double)longitude {
    
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location;
    [self.mapView addAnnotation:annotation];
    //[self.mapView setShowsUserLocation:YES];
}

-(NSString*)getNearestCity :(double)latitude :(double)longitude{
    __block NSString *result;
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         result = placemark.locality; // Extract the city name
        }
     ];
    return result;
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
