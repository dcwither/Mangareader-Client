//
//  MRChapterViewController.m
//  MangaReader
//
//  Created by Devin Witherspoon on 2013-07-11.
//  Copyright (c) 2013 Devin Witherspoon. All rights reserved.
//

#import "MRChapterViewController.h"
#import "MRPageViewController.h"
#import "MRHTTPClient.h"
#import "MRPage.h"

#import <AFNetworking/AFJSONRequestOperation.h>

@interface MRChapterViewController ()

@property (nonatomic, strong) MRChapter *chapter;
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, strong) UIPageViewController *pageController;

- (MRPageViewController *)viewControllerForPageWithIndex:(NSInteger)index;
@end

@implementation MRChapterViewController

- (id)initWithChapter:(MRChapter *)chapter
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.chapter = chapter;
        NSComparator comparator = ^(id obj1, id obj2) {
            MRPage *page1 = (MRPage *)obj1;
            MRPage *page2 = (MRPage *)obj2;
            return [page1.index compare:page2.index];
        };
        
        
        NSURLRequest *request = [[MRHTTPClient sharedClient] requestWithMethod:@"GET" path:self.chapter.path parameters:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            [MRChapter updatePagesForChapter:self.chapter WithJSON:JSON completion:^{
                BOOL shouldUpdate = self.pages.count == 0;
                self.pages = [[self.chapter.pages allObjects] sortedArrayUsingComparator:comparator];
                if (shouldUpdate) {
                    [self.pageController setViewControllers:@[[self viewControllerForPageWithIndex:1]]
                                                  direction:UIPageViewControllerNavigationDirectionForward
                                                   animated:YES
                                                 completion:nil];
                }
            }];

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            TFLog(error.description);
        }];
        
        self.pages = [[self.chapter.pages allObjects] sortedArrayUsingComparator:comparator];
        [operation start];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    // Setting up page controller
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    self.pageController.dataSource = self;
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [self.pageController.view setFrame:self.view.bounds];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
    
    if (self.pages.count > 0) {
        [self.pageController setViewControllers:@[[self viewControllerForPageWithIndex:1]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
        
    } else {
        [self.pageController setViewControllers:@[[[MRPageViewController alloc] initWithPage:nil]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    }
    
}
#pragma mark - PageViewControllerDataSource

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.pages.count;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    MRPage *currentPage = ((MRPageViewController *)viewController).page;
    return [self viewControllerForPageWithIndex:currentPage.indexValue + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    MRPage *currentPage = ((MRPageViewController *)viewController).page;
    return [self viewControllerForPageWithIndex:currentPage.indexValue - 1];
}

#pragma mark - PageViewControllerDelegate

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - Private Methods

- (MRPageViewController *)viewControllerForPageWithIndex:(NSInteger)index
{
    if (index < 1 || index > self.pages.count) {
        return nil;
    }
    
    return [[MRPageViewController alloc] initWithPage:self.pages[index - 1]];
}

@end
