//
//  LPOIntroViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 14/05/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOIntroViewController.h"

@interface LPOIntroViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>

@end

@implementation LPOIntroViewController
{
    CGFloat percentage;
    NSMutableArray *pages;
    NSInteger indexx;
    NSInteger indexxx;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Create the data model
    _pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Começar!"];
    _pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setDelegate:self];
            //            UIScrollView *scrollView = (UIScrollView *)view;
            //            UIPanGestureRecognizer* panGestureRecognizer = scrollView.panGestureRecognizer;
            //            [panGestureRecognizer addTarget:self action:@selector(move:)];
        }
    }
    
    [self makePageViewController];
    
    LPOPageContentViewController *startingViewController = [pages objectAtIndex:0];
    //    startingViewController.pageIndex = 0;
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makePageViewController
{
    pages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.pageTitles.count; i++) {
        // Create a new view controller and pass suitable data.
        
        if (i == self.pageTitles.count -1) {
             LPOStartViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StartPageViewController"];
            pageContentViewController.start = ^{
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            };
            pageContentViewController.titleText = self.pageTitles[i];
            pageContentViewController.imageFile = (i % 2 == 0) ? @"iphone-5-aired-leather-dark" : @"Green-Background-iphone-5-wallpaper-ilikewallpaper_com";
            pageContentViewController.pageIndex = i;
            
            [pages addObject:pageContentViewController];
        } else {
            LPOPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
            pageContentViewController.titleText = self.pageTitles[i];
            pageContentViewController.imageFile = (i % 2 == 0) ? @"iphone-5-aired-leather-dark" : @"Green-Background-iphone-5-wallpaper-ilikewallpaper_com";
            pageContentViewController.titleLabel.textColor = [UIColor blackColor];
            pageContentViewController.pageIndex = i;
            
            [pages addObject:pageContentViewController];

        }
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((LPOPageContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    
    NSLog(@"before");
    index--;
    return [pages objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((LPOPageContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [self.pageTitles count]) {
        return nil;
    }
    
    
    NSLog(@"after");
    indexx = index;
    return [pages objectAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - UIPageViewControllerDelegate

//-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
//{
//    PageContentViewController *nextViewController = (PageContentViewController *)pendingViewControllers[1];
//    [nextViewController.titleLabel setFrame:CGRectMake((nextViewController.titleLabel.frame.origin.x * percentage), nextViewController.titleLabel.frame.origin.y, nextViewController.titleLabel.frame.size.width, nextViewController.titleLabel.frame.size.height)];
//}

#pragma mark - UIScrolViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UIViewController *currentView = [self.pageViewController.viewControllers objectAtIndex:0];
    indexxx = [pages indexOfObject:currentView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x - scrollView.frame.size.width;
    
    LPOPageContentViewController *currentViewController = (LPOPageContentViewController *)[pages objectAtIndex:indexxx];
    currentViewController.titleLabel.center = CGPointMake(scrollView.frame.size.width / 2 - offset * .5, currentViewController.titleLabel.center.y);
    
    if (indexxx > 0) {
        LPOPageContentViewController *previusViewController = (LPOPageContentViewController *)[pages objectAtIndex:indexxx-1];
        previusViewController.titleLabel.center = CGPointMake(- offset * .5, previusViewController.titleLabel.center.y);
    }
    
    if (indexxx < pages.count - 1) {
        LPOPageContentViewController *nextViewController = (LPOPageContentViewController *)[pages objectAtIndex:indexxx+1];
        nextViewController.titleLabel.center = CGPointMake(scrollView.frame.size.width - offset * .5, nextViewController.titleLabel.center.y);
    }
}

@end
