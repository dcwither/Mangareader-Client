//
//  MRChapter.h
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-04.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MRSeries.h"

@interface MRChapter : NSManagedObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSSet *pages;
@property (nonatomic, strong) MRSeries *series;

+ (MRChapter *)insertInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
