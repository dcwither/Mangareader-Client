//
//  MRSelectChapterViewController.m
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-10.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "MRSelectChapterViewController.h"
#import "MRSelectViewController+Protected.h"
#import "MRSeries.h"
#import "MRChapter.h"
#import "MRHTTPClient.h"

#import <AFNetworking/AFJSONRequestOperation.h>
@interface MRSelectChapterViewController ()

@property (nonatomic, strong) MRSeries *series;
@property (nonatomic, strong) NSArray *allChapters;

@end

@implementation MRSelectChapterViewController

- (id)initWithSeries:(MRSeries *)series
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.series = series;
        
        NSURLRequest *request = [[MRHTTPClient sharedClient] requestWithMethod:@"GET" path:self.series.path parameters:nil];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            [MRSeries updateChaptersForSeries:series JSON:JSON completion:^{
                self.allChapters = [[self.series chapters] allObjects];
                [self searchBar:self.searchBar textDidChange:self.searchBar.text];
            }];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            TFLog(error.description);
        }];
        
        [operation start];
        
        self.allChapters = [[self.series chapters] allObjects];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    MRChapter *chapter = self.filteredMembers[indexPath.row];
    cell.textLabel.text = chapter.title;
    
    return cell;
}

#pragma mark - ProtectedMembers

- (NSArray *)getAllMembers
{
    return self.allChapters;
}

@end
