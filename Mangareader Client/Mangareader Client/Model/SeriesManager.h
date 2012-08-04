//
//  SeriesManager.h
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-04.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRSeries.h"
#import "MRChapter.h"

@class SeriesManager;

@interface SeriesManager : NSObject

+ (SeriesManager *) sharedManager;
- (void) updatAvailableSeries;
- (void) updateChaptersForSeries: (MRSeries *) series;
    
@end
