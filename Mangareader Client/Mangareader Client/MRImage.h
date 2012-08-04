//
//  MRImage.h
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-04.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MRSeries.h"

@interface MRImage : NSManagedObject

@property (nonatomic, strong) NSData *image;

@property (nonatomic, strong) MRSeries *series;

@end
