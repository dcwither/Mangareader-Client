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

@implementation SeriesManager

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
        NSURL *seriesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@,%@",BASE_URL,series.url]];
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
@end
