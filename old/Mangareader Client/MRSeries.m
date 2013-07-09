//
//  GRSeries.m
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-04.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import "MRSeries.h"

@implementation MRSeries

@dynamic name;
@dynamic url;
@dynamic chapters;
@dynamic image;

+ (MRSeries *)insertInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    
    return (MRSeries *)[NSEntityDescription insertNewObjectForEntityForName:@"MRSeries"
                                                    inManagedObjectContext:managedObjectContext];
}

@end
