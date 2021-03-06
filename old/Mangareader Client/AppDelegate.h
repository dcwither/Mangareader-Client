//
//  AppDelegate.h
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-03.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BASE_URL @"http://dcwither-udacity-projects.appspot.com"
#define APP_DELEGATE() ((AppDelegate *) [[UIApplication sharedApplication] delegate])


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
