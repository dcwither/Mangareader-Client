#import "MRChapter.h"
#import "MRPage.h"

@interface MRChapter ()

// Private interface goes here.

@end


@implementation MRChapter

+ (void)updatePagesForChapter:(MRChapter *)chapter WithJSON:(NSArray *)JSON completion:(void (^)( ))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        MRChapter *currentThreadChapter = (MRChapter *)[[NSManagedObjectContext contextForCurrentThread] objectWithID:chapter.objectID];
        
        for (NSDictionary *dict in JSON) {
            NSInteger index = [dict[@"index"] intValue];
            NSString *url = dict[@"image_url"];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"index == %d", index];
            NSArray *pages = [[[currentThreadChapter pages] filteredSetUsingPredicate:predicate] allObjects];
            
            NSAssert(pages.count <= 1, @"Number of pages matching this description exceeded the expected range.");
            
            MRPage *page;
            if (0 == pages.count) {
                page = [MRPage insertInManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
            } else {
                page = pages[0];
            }
            
            page.url = url;
            page.indexValue = index;
            page.chapter = currentThreadChapter;
            [currentThreadChapter.pagesSet addObject:page];
        }
        
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        
        if (completion) {
            dispatch_sync(dispatch_get_main_queue(), completion);
        }
    });
}

@end
