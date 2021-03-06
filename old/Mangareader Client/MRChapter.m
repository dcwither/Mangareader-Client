//
//  MRChapter.m
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-04.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import "MRChapter.h"

@implementation MRChapter

@dynamic index;
@dynamic pageCount;
@dynamic title;
@dynamic url;
@dynamic pages;
@dynamic series;

+ (MRChapter *)insertInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    
    return (MRChapter *)[NSEntityDescription insertNewObjectForEntityForName:@"MRChapter"
                                                     inManagedObjectContext:managedObjectContext];
}

@end
