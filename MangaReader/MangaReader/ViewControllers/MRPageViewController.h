//
//  MRPageViewController.h
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-11.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRPage.h"

@interface MRPageViewController : UIViewController

@property (nonatomic, strong, readonly) MRPage *page;

- (id)initWithPage:(MRPage *)page;
@end
