//
//  LPOIntroViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 14/05/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOIntroViewController.h"

@interface LPOIntroViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *contentPages;

@end

@implementation LPOIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pageTitles = @[NSLocalizedString(@"intro-text-1", nil), NSLocalizedString(@"intro-text-2", nil), NSLocalizedString(@"intro-text-3", nil), NSLocalizedString(@"intro-text-4", nil)];
    _pageImages = @[NSLocalizedString(@"intro-image-1", nil), NSLocalizedString(@"intro-image-2", nil), NSLocalizedString(@"intro-image-3", nil), NSLocalizedString(@"intro-image-4", nil)];
    
    [self.pageIndicator setNumberOfPages:self.pageTitles.count];
 
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setDelegate:self];
        }
    }
    
    [self makePageViewController];
    
    LPOPageContentViewController *startingViewController = [self.contentPages objectAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view bringSubviewToFront:self.pageIndicator];
}

- (void)makePageViewController
{
    self.contentPages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.pageTitles.count; i++) {
        // Create a new view controller and pass suitable data.
        
        if (i == self.pageTitles.count -1) {
             LPOStartViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StartPageViewController"];
            pageContentViewController.titleText = self.pageTitles[i];
            pageContentViewController.imageFile = self.pageImages[i];
            pageContentViewController.pageIndex = i;
            
            [self.contentPages addObject:pageContentViewController];
        } else {
            LPOPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
            pageContentViewController.titleText = self.pageTitles[i];
            pageContentViewController.imageFile = self.pageImages[i];
            pageContentViewController.titleLabel.textColor = [UIColor blackColor];
            pageContentViewController.pageIndex = i;
            
            [self.contentPages addObject:pageContentViewController];

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
    
    index--;
    return [self.contentPages objectAtIndex:index];
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
    
    return [self.contentPages objectAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - UIScrolViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UIViewController *currentView = [self.pageViewController.viewControllers objectAtIndex:0];
    self.currentPage = [self.contentPages indexOfObject:currentView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x - scrollView.frame.size.width;

    if (offset > 0) {
        if (offset > 160) {
            [self.pageIndicator setCurrentPage:self.currentPage + 1];
        } else if (offset < 160) {
            [self.pageIndicator setCurrentPage:self.currentPage];
        }
    }

    if (offset < 0) {
        if (- offset > 160) {
            [self.pageIndicator setCurrentPage:self.currentPage - 1];
        } else if (- offset < 160) {
            [self.pageIndicator setCurrentPage:self.currentPage];
        }
    }
    
    LPOPageContentViewController *currentViewController = (LPOPageContentViewController *)[self.contentPages objectAtIndex:self.currentPage];
    currentViewController.titleLabel.center = CGPointMake(scrollView.frame.size.width / 2 - offset * .5, currentViewController.titleLabel.center.y);
    
    if (self.currentPage > 0) {
        LPOPageContentViewController *previusViewController = (LPOPageContentViewController *)[self.contentPages objectAtIndex:self.currentPage - 1];
        previusViewController.titleLabel.center = CGPointMake(- offset * .5, previusViewController.titleLabel.center.y);
    }
    
    if (self.currentPage < self.contentPages.count - 1) {
        LPOPageContentViewController *nextViewController = (LPOPageContentViewController *)[self.contentPages objectAtIndex:self.currentPage + 1];
        nextViewController.titleLabel.center = CGPointMake(scrollView.frame.size.width - offset * .5, nextViewController.titleLabel.center.y);
    }
}

@end
