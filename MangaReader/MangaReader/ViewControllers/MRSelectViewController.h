//
//  MRSelectViewController.h
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-10.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import <PKRevealController/PKRevealController.h>
#import <UIKit/UIKit.h>

@interface MRSelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) PKRevealController *revealController;

@end
