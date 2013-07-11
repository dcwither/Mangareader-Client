//
//  MRChapterViewController.h
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-11.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "MRChapter.h"
#import <UIKit/UIKit.h>

@interface MRChapterViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (id)initWithChapter:(MRChapter *)chapter;

@end
