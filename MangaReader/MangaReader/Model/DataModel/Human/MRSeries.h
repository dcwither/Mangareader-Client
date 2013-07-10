#import "_MRSeries.h"

@interface MRSeries : _MRSeries {}
// Custom logic goes here.

+ (void)updateAllSeriesWithJSON:(NSArray *)JSON completion:(void (^)( ))completion;

@end
