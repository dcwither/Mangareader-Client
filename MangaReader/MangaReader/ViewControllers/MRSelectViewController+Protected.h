//
//  MRSelectViewController+Protected.h
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-10.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "MRSelectViewController.h"

@interface MRSelectViewController (Protected)

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *filteredMembers;

- (NSArray *)getAllMembers;

@end
