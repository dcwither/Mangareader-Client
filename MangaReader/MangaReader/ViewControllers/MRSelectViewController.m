//
//  MRSelectViewController.m
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-10.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "MRSelectViewController.h"
#import "MRSelectViewController+Protected.h"

@interface MRSelectViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *filteredMembers;
@property (nonatomic, strong) NSString *predicatePrefix;

@end

@implementation MRSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
}


#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredMembers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"series cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"series cell"];
    }
    
    return cell;
}

#pragma mark - SearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSAssert(self.predicatePrefix != nil, @"No predicate has been defined for the search field");
    
    if (searchText == nil || [searchText length] == 0) {
        self.filteredMembers = [self getAllMembers];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:self.predicatePrefix, searchText];
        self.filteredMembers = [[self getAllMembers] filteredArrayUsingPredicate:predicate];
    }
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

#pragma mark - Protected Methods

- (NSArray *)getAllMembers
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    
    return nil;
}

@end
