//
//  GRSeries.h
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-04.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MRSeries : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSSet *chapters;

@property (nonatomic, strong) NSData *image;

+ (MRSeries *)insertInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
