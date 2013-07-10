#import "MRSeries.h"
#import "MRChapter.h"


@interface MRSeries ()

// Private interface goes here.

@end


@implementation MRSeries

// Custom logic goes here.

+ (void)updateAllSeriesWithJSON:(NSArray *)JSON completion:(void (^)( ))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (NSDictionary *dict in JSON) {
            NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
            NSString *name = [dict[@"name"] stringByTrimmingCharactersInSet:whitespaceCharacterSet];
            NSString *path = [dict[@"path"] stringByTrimmingCharactersInSet:whitespaceCharacterSet];
            MRSeries *series = [self findFirstByAttribute:MRSeriesAttributes.name withValue:name];
            if (nil == series) {
                series = [self insertInManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
            }
            
            series.name = name;
            series.path = path;
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

+ (void)updateChaptersForSeries:(MRSeries *)series JSON:(NSArray *)JSON completion:(void (^)( ))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        MRSeries *currentThreadSeries = (MRSeries *)[[NSManagedObjectContext contextForCurrentThread] objectWithID:series.objectID];
        
        for (NSDictionary *dict in JSON) {
            NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
            NSString *title = [dict[@"name"] stringByTrimmingCharactersInSet:whitespaceCharacterSet];
            NSString *path = [dict[@"path"] stringByTrimmingCharactersInSet:whitespaceCharacterSet];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", title];
            NSArray *chapters = [[[currentThreadSeries chapters] filteredSetUsingPredicate:predicate] allObjects];
            
            NSAssert(chapters.count <= 1, @"Number of chapters matching this description exceeded the expected range.");
            
            MRChapter *chapter;
            if (0 == chapters.count) {
                chapter = [MRChapter insertInManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
            } else {
                chapter = chapters[0];
            }
            
            chapter.title = title;
            chapter.path = path;
            chapter.series = currentThreadSeries;
            [currentThreadSeries.chaptersSet addObject:chapter];
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
