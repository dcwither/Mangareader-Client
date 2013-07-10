//
//  MRSelectSeriesViewController.m
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-09.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "MRSelectSeriesViewController.h"
#import "MRSeries.h"
#import "MRHTTPClient.h"

#import <AFNetworking/AFJSONRequestOperation.h>

@interface MRSelectSeriesViewController ()

@property (nonatomic, strong) NSArray *allSeries;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *filteredSeries;

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
        
        self.allSeries = [MRSeries findAllSortedBy:MRSeriesAttributes.name ascending:YES];
        self.filteredSeries = self.allSeries;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:frame];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    frame.origin.y = self.searchBar.frame.size.height;
    frame.size.height = self.view.frame.size.height - frame.origin.y;
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    self.searchBar.userInteractionEnabled = YES;
}


#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredSeries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"series cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"series cell"];
    }
    
    MRSeries *series = self.filteredSeries[indexPath.row];
    cell.textLabel.text = series.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - SearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText == nil || [searchText length] == 0) {
        self.filteredSeries = self.allSeries;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name beginswith[cd] %@", searchText];
        self.filteredSeries = [self.allSeries filteredArrayUsingPredicate:predicate];
    }
    
    [self.tableView reloadData];
}

@end
