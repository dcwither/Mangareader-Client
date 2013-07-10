//
//  MRSelectChapterViewController.h
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-10.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "MRSelectViewController.h"
#import "MRSeries.h"

#import <UIKit/UIKit.h>

@interface MRSelectChapterViewController : MRSelectViewController


- (id)initWithSeries:(MRSeries *)series;
@end
