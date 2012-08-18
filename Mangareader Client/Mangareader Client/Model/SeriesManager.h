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
#import "MRPage.h"

@class SeriesManager;

@protocol PageViewer <NSObject>

- (void) pageRecieved:(MRPage *)page;

@end

@interface SeriesManager : NSObject

+ (SeriesManager *) sharedManager;
- (void) updateAvailableSeries;
- (void) updateChaptersForSeries: (MRSeries *) series;
- (void)updatePagesForChapter: (MRChapter *) chapter;

@property (nonatomic, weak) id<PageViewer> pageViewer;
@property (nonatomic, strong) NSOperationQueue *seriesQueue;
@property (nonatomic, strong) NSOperationQueue *chapterQueue;
@property (nonatomic, strong) NSOperationQueue *pageQueue;

@end
