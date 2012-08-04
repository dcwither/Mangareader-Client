//
//  SeriesManager.m
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-04.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import "SeriesManager.h"
#import "AppDelegate.h"
#import "MRSeries.h"
#import "MRChapter.h"
#import "MRPage.h"

static SeriesManager *instance = NULL;

@implementation SeriesManager

@synthesize pageViewer = _pageViewer;
@synthesize seriesQueue = _seriesQueue;
@synthesize pageQueue = _pageQueue;

+ (SeriesManager *)sharedManager
{
    @synchronized (self) {
        if (instance != NULL) {
            return instance;
            
        } else {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
    
}

- (id) init
{
    if (self = [super init]) {
        self.seriesQueue = [[NSOperationQueue alloc] init];
        self.chapterQueue = [[NSOperationQueue alloc] init];
        self.pageQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)updatAvailableSeries
{
    NSManagedObjectContext *context = APP_DELEGATE().managedObjectContext;
    
    //
    // Series Queue Operation
    //
    
    if (![self.seriesQueue isSuspended]) {
        return;
    }
    
    [self.seriesQueue  addOperationWithBlock:^{
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BASE_URL]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:100];
        
        [urlRequest setHTTPMethod: @"GET"];
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest
                                                 returningResponse:&urlResponse
                                                             error:&requestError];
        
        NSError *jsonError;
        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:response
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
        
        if (jsonError) {
            NSLog(@"Error: %@ response failed on json: %@", jsonError, BASE_URL);
        }
        
        //
        // Core data operations
        //
        
        [context performBlock:^{
            NSError *error;
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MRSeries"];
            for (NSDictionary *series in jsonResponse) {
                NSString *name = [series objectForKey:@"name"];
                NSString *url = [series objectForKey:@"link"];
                
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
                NSInteger count = [context countForFetchRequest:fetchRequest error:&error];
                if (count == 0) {
                    MRSeries *seriesInstance = [MRSeries insertInManagedObjectContext:context];
                    seriesInstance.image = nil;
                    seriesInstance.url = url;
                    seriesInstance.name = name;
                }
            }
            
            [context save:&error];
            if (jsonError) {
                NSLog(@"Error saving series: %@", error);
            }
        }];
        
    }];
}

- (void)updateChaptersForSeries: (MRSeries *) series
{
    NSManagedObjectContext *context = APP_DELEGATE().managedObjectContext;
    if (![self.chapterQueue isSuspended]) {
        
        //
        // Won't cancel the current running operation. Could be improved to stop at safe points.
        //
        
        [self.chapterQueue cancelAllOperations];
    }
    
    [self.chapterQueue addOperationWithBlock:^{
        NSURL *seriesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,series.url]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:seriesURL
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:100];
        
        [urlRequest setHTTPMethod: @"GET"];
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest
                                                 returningResponse:&urlResponse
                                                             error:&requestError];
        
        if (requestError) {
            NSLog(@"Error: %@ response failed on url: %@", requestError, seriesURL);
        }
        
        NSError *jsonError;
        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:response
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jsonError];
        
        if (jsonError) {
            NSLog(@"Error: %@ response failed on json: %@", jsonError, seriesURL);
        }
        
        [context performBlock:^{
            NSError *error;
            NSInteger index = 0;
            for (NSDictionary *chapter in jsonResponse) {
                index++;
                NSString *name = [chapter objectForKey:@"name"];
                NSString *url = [chapter objectForKey:@"link"];
                
                NSSet *filtered = [series.chapters filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", name]];
                if ([filtered count] == 0) {
                    MRChapter *chapterInstance = [MRChapter insertInManagedObjectContext:context];
                    chapterInstance.url = url;
                    chapterInstance.title = name;
                    chapterInstance.series = series;
                    chapterInstance.index = index;
                    series.chapters = [series.chapters setByAddingObject:chapterInstance];
                }
            }
            
            [context save:&error];
            if (error) {
                NSLog(@"Error saving series: %@", error);
            }
        }];
        
    }];
    
}

- (void)updatePagesForChapter: (MRChapter *) chapter
{
    if ([chapter.pages count] == chapter.pageCount && chapter.pageCount >= 0) {
        //Already has the pages. They shouldn't have to be reloaded.
        return;
    }
    
    NSManagedObjectContext *context = APP_DELEGATE().managedObjectContext;
    
    if (![self.pageQueue isSuspended]) {
        
        //
        // Won't cancel the current running operation. Could be improved to stop at safe points.
        //
        
        [self.pageQueue cancelAllOperations];
    }
    
    [self.pageQueue addOperationWithBlock:^{
        NSURL *chapterURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,chapter.url]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:chapterURL
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:100];
        
        [urlRequest setHTTPMethod: @"GET"];
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest
                                                 returningResponse:&urlResponse
                                                             error:&requestError];
        
        if (requestError) {
            NSLog(@"Error: %@ response failed on url: %@", requestError, chapterURL);
        }
        
        NSError *jsonError;
        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:response
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jsonError];
        
        if (jsonError) {
            NSLog(@"Error: %@ response failed on json: %@", jsonError, chapterURL);
        }
        
        [context performBlock:^{
            NSError *error;
            
            chapter.pageCount = [jsonResponse count];
            
            for (NSDictionary *page in jsonResponse) {
                NSInteger index = [[page objectForKey:@"index"] intValue];
                NSString *url = [page objectForKey:@"image_url"];
                NSSet *filtered = [chapter.pages filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"(index == %d)", index]];
                MRPage *pageInstance = nil;
                if ([filtered count] == 0) {
                    
                    pageInstance = [MRPage insertInManagedObjectContext:context];
                    pageInstance.url = url;
                    pageInstance.index = index;
                    chapter.pages = [chapter.pages setByAddingObject:pageInstance];
                    
                } else {
                    assert([filtered count] == 1);
                    pageInstance = [[filtered objectEnumerator] nextObject];
                }
                
                if (pageInstance.image == nil) {
                    [context performBlock:^{
                        [self fetchImageForPage:pageInstance];
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [self.pageViewer pageRecieved:pageInstance];
                        }];
                    }];
                } else {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.pageViewer pageRecieved:pageInstance];
                    }];
                }
            }
            
            [context save:&error];
            if (error) {
                
                NSLog(@"Error saving chapter: %@", error);
            }
        }];
        
    }];
}

- (void) fetchImageForPage: (MRPage *) page
{
    
    NSManagedObjectContext *context = APP_DELEGATE().managedObjectContext;
    NSURL *pageURL = [NSURL URLWithString:page.url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pageURL
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                          timeoutInterval:100];
    
    [urlRequest setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest
                                             returningResponse:&urlResponse
                                                         error:&requestError];
    
    if (requestError) {
        NSLog(@"Error: %@ response failed on url: %@", requestError, pageURL);
    }
    
    page.image = response;
    NSError *error;
    [context save:&error];
    if (error) {
        NSLog(@"Error saving page");
    }
    
}

@end
