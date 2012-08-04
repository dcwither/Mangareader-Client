//
//  ChapterViewController.m
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-04.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import "ChapterViewController.h"

@interface ChapterViewController ()

@property (nonatomic, strong) UIImageView *pageView;

- (void) loadPage: (NSInteger) pageIndex;

@end

@implementation ChapterViewController

@synthesize chapter = _chapter;
@synthesize pageIndex = _pageIndex;
@synthesize loadedPages = _loadedPages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView
{
    
    [super loadView];
    self.pageIndex = 0;
    self.loadedPages = MAX(0, self.chapter.pageCount);
    self.pageView = [[UIImageView alloc] initWithImage:nil];
    [self.view addSubview:self.pageView];
    [SeriesManager sharedManager].pageViewer = self;
    
    if (self.chapter.pageCount != [self.chapter.pages count] || self.chapter.pageCount < 0) {
        [[SeriesManager sharedManager] updatePagesForChapter:self.chapter];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    if ([SeriesManager sharedManager].pageViewer == self) {
        [SeriesManager sharedManager].pageViewer = nil;
    }
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.chapter.pages count] >= 1) {
        [self loadPage:1];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.pageView.frame = [self calculateFrameOfImageToFitScreen:self.pageView.image];
}

#pragma mark - User Actions

- (IBAction)swipeRight:(id)sender
{
    if (self.pageIndex - 1 >= 1) {
        [self loadPage: self.pageIndex - 1];
    }
}

- (IBAction)swipeLeft:(id)sender
{
    if (self.pageIndex + 1 <= self.loadedPages) {
        [self loadPage:self.pageIndex +1];
    }
}

- (IBAction)cancelButtonPressed:(id)sender
{
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Page View Methods

- (void) loadPage:(NSInteger)pageIndex
{
    NSSet *selected = [self.chapter.pages filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"index == %d", pageIndex]];
    for (MRPage *page in selected) {
        self.pageIndex = pageIndex;
        UIImage *image = [UIImage imageWithData:page.image];
        self.pageView.image = image;
        self.pageView.frame = [self calculateFrameOfImageToFitScreen:image];
    }
}

- (void) pageRecieved:(MRPage *)page
{
    
    if (self.loadedPages == 0) {
        [self loadPage:1];
    }
    
    self.loadedPages += 1;
}

- (CGRect) calculateFrameOfImageToFitScreen:(UIImage *) image
{
    
    CGRect Frame;
    Frame = CGRectZero;
    CGFloat widthFactor = self.view.frame.size.width / image.size.width;
    CGFloat heightFactor = self.view.frame.size.height / image.size.height;
    if (widthFactor > 1 && heightFactor > 1) {
        Frame.size.height = image.size.height;
        Frame.size.width = image.size.width;
    } else {
        CGFloat Height = MIN(self.view.frame.size.height, image.size.height);
        CGFloat Width = MIN(self.view.frame.size.width, image.size.width);
        if (widthFactor > heightFactor) {
            Frame.size.height = Height;
            Frame.size.width = image.size.width * (Height / image.size.height);
        } else {
            Frame.size.width = Width;
            Frame.size.height = image.size.height * (Width / image.size.width);
        }
    }
    
    Frame.origin.x = (self.view.frame.size.width - Frame.size.width) / 2;
    Frame.origin.y = (self.view.frame.size.height - Frame.size.height) / 2;
    return Frame;
}

@end