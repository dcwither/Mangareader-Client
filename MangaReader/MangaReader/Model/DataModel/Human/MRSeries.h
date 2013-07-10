#import "_MRSeries.h"

@interface MRSeries : _MRSeries {}
// Custom logic goes here.

+ (void)updateAllSeriesWithJSON:(NSArray *)JSON completion:(void (^)( ))completion;
+ (void)updateChaptersForSeries:(MRSeries *)series JSON:(NSArray *)JSON completion:(void (^)( ))completion;

@end
