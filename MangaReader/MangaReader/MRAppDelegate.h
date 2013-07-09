//
//  MRAppDelegate.h
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-09.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;

@end
