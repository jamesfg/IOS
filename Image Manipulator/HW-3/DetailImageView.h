//
//  DetailImageView.h
//  HW-3
//
//  Created by Muhammad Naviwala on 11/4/14.
//  Copyright (c) 2014 Muhammad Naviwala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailImageView : UIViewController < UIAlertViewDelegate> {
    
    CGFloat _lastScale;
    CGFloat _lastRotation;
    CGFloat _firstX;
    CGFloat _firstY;
    
    UIView *canvas;
    
    CAShapeLayer *_marque;
}
@property (weak, nonatomic) IBOutlet UIImageView *theImage;

@property UIImage *imageToAssign;

- (IBAction)longPressDetected:(UILongPressGestureRecognizer *)sender;
- (UIImage*)drawWatermarkText:(NSString*)text;

@end
