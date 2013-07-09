//
//  MRPage.h
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-04.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MRChapter.h"

@interface MRPage : NSManagedObject

@property (nonatomic, strong) NSData *image;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) MRChapter *chapter;

+ (MRPage *)insertInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
