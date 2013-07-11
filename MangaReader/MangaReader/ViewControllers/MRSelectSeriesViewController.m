//
//  MRSelectSeriesViewController.m
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-09.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "MRSelectSeriesViewController.h"
#import "MRSelectViewController+Protected.h"
#import "MRSelectChapterViewController.h"
#import "MRSeries.h"
#import "MRHTTPClient.h"

#import <AFNetworking/AFJSONRequestOperation.h>

@interface MRSelectSeriesViewController ()

@property (nonatomic, strong) NSArray *allSeries;

@end

@implementation MRSelectSeriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSURLRequest *request = [[MRHTTPClient sharedClient] requestWithMethod:@"GET" path:@"all" parameters:nil];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            [MRSeries updateAllSeriesWithJSON:JSON completion:^{
                self.allSeries = [MRSeries findAllSortedBy:MRSeriesAttributes.name ascending:YES];
                [self searchBar:self.searchBar textDidChange:self.searchBar.text];
            }];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            TFLog(error.description);
        }];
        
        [operation start];
        self.predicatePrefix = @"name beginswith[cd] %@";
        self.allSeries = [MRSeries findAllSortedBy:MRSeriesAttributes.name ascending:YES];
        self.filteredMembers = self.allSeries;
    }
    return self;
}

#pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    MRSeries *series = self.filteredMembers[indexPath.row];
    cell.textLabel.text = series.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MRSeries *selectedSeries = self.filteredMembers[indexPath.row];
    MRSelectChapterViewController *chapterViewController = [[MRSelectChapterViewController alloc] initWithSeries:selectedSeries];
    chapterViewController.revealController = self.revealController;
    
    [self.navigationController pushViewController:chapterViewController animated:YES];
}

#pragma mark - Protected Methods

- (NSArray *)getAllMembers
{
    return self.allSeries;
}

@end
