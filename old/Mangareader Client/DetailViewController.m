//
//  DetailViewController.m
//  Mangareader Client
//
//  Created by Devin Witherspoon on 2012-08-03.
//  Copyright (c) 2012 SmrtStudios. All rights reserved.
//

#import "DetailViewController.h"
#import "MRSeries.h"
#import "MRChapter.h"
#import "AppDelegate.h"

@interface DetailViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;

@end

@implementation DetailViewController

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if ([[self.detailItem class] isSubclassOfClass:[MRSeries class]]) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"name"] description];
        self.title = [[self.detailItem valueForKey:@"name"] description];
    } else if ([[self.detailItem class] isSubclassOfClass:[MRChapter class]]) {
        self.fetchedResultsController = nil;
        NSFetchedResultsController *controller = self.fetchedResultsController;
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - FetchedResultsController


@end
