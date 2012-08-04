//
//  DetailViewController.h
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-03.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
