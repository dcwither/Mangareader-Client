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

+ (SeriesManager *) sharedManager
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

- (void) updatAvailableSeries
{
    NSManagedObjectContext *context = APP_DELEGATE().managedObjectContext;
    [context performBlock:^{
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BASE_URL]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:10];
        
        [urlRequest setHTTPMethod: @"GET"];
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest
                                                 returningResponse:&urlResponse
                                                             error:&requestError];
        
        NSError *error;
        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:response
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
        
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
        if (error) {
            NSLog(@"Error saving series");
        }
    }];
}

- (void) updateChaptersForSeries: (MRSeries *) series
{
    NSManagedObjectContext *context = APP_DELEGATE().managedObjectContext;
    [context performBlock:^{
        NSURL *seriesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,series.url]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:seriesURL
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:10];
        
        [urlRequest setHTTPMethod: @"GET"];
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest
                                                 returningResponse:&urlResponse
                                                             error:&requestError];
        
        NSError *error;
        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:response
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MRChapter"];
        NSInteger index = 0;
        for (NSDictionary *chapter in jsonResponse) {
            index++;
            NSString *name = [chapter objectForKey:@"name"];
            NSString *url = [chapter objectForKey:@"link"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title == %@", name];
            NSInteger count = [context countForFetchRequest:fetchRequest error:&error];
            if (count == 0) {
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
            NSLog(@"Error saving series");
        }
    }];
    
}

- (void) updatePagesForChapter: (MRChapter *) chapter
{
    
    NSManagedObjectContext *context = APP_DELEGATE().managedObjectContext;
    [context performBlock:^{
        NSURL *seriesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,chapter.url]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:seriesURL
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:10];
        
        [urlRequest setHTTPMethod: @"GET"];
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest
                                                 returningResponse:&urlResponse
                                                             error:&requestError];
        
        NSError *error;
        NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:response
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MRPage"];
        for (NSDictionary *page in jsonResponse) {
            NSInteger index = [[page objectForKey:@"index"] intValue];
            NSString *url = [page objectForKey:@"image_url"];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title == %@", index];
            NSInteger count = [context countForFetchRequest:fetchRequest error:&error];
            if (count == 0) {
                MRPage *pageInstance = [MRPage insertInManagedObjectContext:context];
                pageInstance.url = url;
                pageInstance.index = index;
                chapter.pages = [chapter.pages setByAddingObject:pageInstance];
                [context performBlock:^{
                    
                }];
            }
        }
        
        [context save:&error];
        if (error) {
            NSLog(@"Error saving chapter");
        }
    }];
}

- (void) fetchImageForPage: (MRPage *) page
{
    
    NSManagedObjectContext *context = APP_DELEGATE().managedObjectContext;
    NSURL *pageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,page.url]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pageURL
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                          timeoutInterval:10];
    
    [urlRequest setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest
                                             returningResponse:&urlResponse
                                                         error:&requestError];
    
    page.image = response;
    NSError *error;
    [context save:&error];
    if (error) {
        NSLog(@"Error saving page");
    }
    
}

@end
