//
//  MRPageViewController.m
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-11.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "MRPageViewController.h"

@interface MRPageViewController ()

@property (nonatomic, strong) MRPage *page;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MRPageViewController

- (id)initWithPage:(MRPage *)page
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.page = page;
        [MRPage downloadImageForPage:self.page completion:^(UIImage *image) {
            self.imageView.image = image;
            [self resizeImageView];
        }];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    
    if (self.page.image) {
        self.imageView.image = [UIImage imageWithData:self.page.image];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resizeImageView];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self resizeImageView];
}

- (void)resizeImageView
{
    [self.imageView sizeToFit];
    // TODO: iPad specific code. Should not require this function
    CGSize boundsSize;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        boundsSize = CGSizeMake(1024, 704);
    } else {
        boundsSize = CGSizeMake(768, 960);
    }
    
    CGRect frameToCenter = self.imageView.frame;
    
    CGFloat boundFactor = MAX(self.imageView.frame.size.width / boundsSize.width, self.imageView.frame.size.height / boundsSize.height);
    if (boundFactor > 0) {
        frameToCenter.size = CGSizeMake(frameToCenter.size.width / boundFactor, frameToCenter.size.height / boundFactor);
    }
    
    // center horizontally
    frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    
    // center vertically
    frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    
    self.imageView.frame = frameToCenter;
}

@end
