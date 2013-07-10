#import "MRSeries.h"


@interface MRSeries ()

// Private interface goes here.

@end


@implementation MRSeries

// Custom logic goes here.

+ (void)updateAllSeriesWithJSON:(NSArray *)JSON completion:(void (^)( ))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (NSDictionary *dict in JSON) {
            NSString *name = dict[@"name"];
            if (name && [self findFirstByAttribute:MRSeriesAttributes.name withValue:name]) {
                continue;
            }
            
            MRSeries *series = [self insertInManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
            series.name = name;
            series.path = dict[@"path"];
        }
        NSError *error;
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        
        if (error) {
            TFLog(error.description);
        }
        
        if (completion) {
            dispatch_sync(dispatch_get_main_queue(), completion);
        }
    });
}

@end
