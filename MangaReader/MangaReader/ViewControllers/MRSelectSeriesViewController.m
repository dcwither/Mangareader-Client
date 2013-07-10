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
                [self.tableView reloadData];
            }];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            TFLog(error.description);
        }];
        
        [operation start];
        
        self.allSeries = [MRSeries findAllSortedBy:MRSeriesAttributes.name ascending:YES];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allSeries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"series cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"series cell"];
    }
    
    MRSeries *series = self.allSeries[indexPath.row];
    cell.textLabel.text = series.name;
    
    return cell;
}

@end
