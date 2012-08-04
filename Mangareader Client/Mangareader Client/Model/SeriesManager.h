//
//  SeriesManager.h
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-04.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SeriesManager;

@protocol SeriesManagerDelegate <NSObject>

- (void)seriesMangerDidUpdateAvailableSeries: (SeriesManager *) seriesManager;

@end

@interface SeriesManager : NSObject

@property (nonatomic, weak) id<SeriesManagerDelegate> delegate;

- (void) updatAvailableSeries;
    
@end
