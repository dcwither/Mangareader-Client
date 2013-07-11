#import "MRSeries.h"
#import "MRChapter.h"


static dispatch_queue_t allSeriesQueue;
static dispatch_queue_t allChapterQueue;

@interface MRSeries ()

// Private interface goes here.

@end


@implementation MRSeries

// Custom logic goes here.

+ (void)updateAllSeriesWithJSON:(NSArray *)JSON completion:(void (^)( ))completion
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allSeriesQueue = dispatch_queue_create("All Chapters", DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_async(allSeriesQueue, ^{
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
        
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        
        if (completion) {
            dispatch_sync(dispatch_get_main_queue(), completion);
        }
    });
}

+ (void)updateChaptersForSeries:(MRSeries *)series JSON:(NSArray *)JSON completion:(void (^)( ))completion
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allChapterQueue = dispatch_queue_create("All Chapters", DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_async(allChapterQueue, ^{
        MRSeries *currentThreadSeries = (MRSeries *)[[NSManagedObjectContext contextForCurrentThread] objectWithID:series.objectID];
        
        NSInteger index = 1;
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
            chapter.indexValue = index++;
            [currentThreadSeries.chaptersSet addObject:chapter];
        }
        
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        
        if (completion) {
            dispatch_sync(dispatch_get_main_queue(), completion);
        }
    });
}

@end
