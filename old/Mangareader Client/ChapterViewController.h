//
//  ChapterViewController.h
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-04.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRChapter.h"
#import "MRPage.h"
#import "SeriesManager.h"

@interface ChapterViewController : UIViewController <PageViewer>

@property (nonatomic, strong) MRChapter *chapter;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger loadedPages;

- (IBAction)swipeRight:(id)sender;
- (IBAction)swipeLeft:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
