//
//  MRAppDelegate.m
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-09.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "MRAppDelegate.h"
#import "MRSelectSeriesViewController.h"
#import <PKRevealController/PKRevealController.h>

@implementation MRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"MangaReader.sqlite"];
    
    UIViewController *frontViewController = [[UIViewController alloc] init];
    UIViewController *leftViewController = [[MRSelectSeriesViewController alloc] init];
    UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:leftViewController];
    UINavigationController *frontNav = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    PKRevealController *revealController = [[PKRevealController alloc] initWithFrontViewController:frontNav
                                                                                leftViewController:leftNav
                                                                                           options:nil];
    
    leftViewController.revealController = revealController;
    self.window.rootViewController = revealController;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
