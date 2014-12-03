//
//  Team3AppDelegate.h
//  Team3HW2
//
//  Created by Gabe on 10/5/14.
//  Copyright (c) 2014 UH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Team3AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
