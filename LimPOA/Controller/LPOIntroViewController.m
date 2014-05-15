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
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation LPOIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pageTitles = @[@"Matenha a cidade limpa", @"Não encontrou uma lixeira próxima?", @"Convide seus amigos", @"Começar!"];
    _pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    
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

-(void)viewDidAppear:(BOOL)animated
{
    [self loadDumpsData];
}

- (void)makePageViewController
{
    self.contentPages = [[NSMutableArray alloc] init];
    
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
            
            [self.contentPages addObject:pageContentViewController];
        } else {
            LPOPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
            pageContentViewController.titleText = self.pageTitles[i];
            pageContentViewController.imageFile = (i % 2 == 0) ? @"iphone-5-aired-leather-dark" : @"Green-Background-iphone-5-wallpaper-ilikewallpaper_com";
            pageContentViewController.titleLabel.textColor = [UIColor blackColor];
            pageContentViewController.pageIndex = i;
            
            [self.contentPages addObject:pageContentViewController];

        }
    }
}

#pragma Lazy Instantiation

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(LPOAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return _context;
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

#pragma mark - Load data

- (void)loadDumpsData
{
    NSCharacterSet *commaSet;
    commaSet = [NSCharacterSet characterSetWithCharactersInString:@","];
    
    NSError *error;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Dump" ofType:@"txt"];
    NSString *dataFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding  error:&error];
    
    
    NSArray *dataFileLines = [dataFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (int i = 0; i <= dataFileLines.count - 1; i++) {
        Dump *dump = (Dump *)[NSEntityDescription insertNewObjectForEntityForName:@"Dump" inManagedObjectContext:self.context];
        
        NSArray *fields = [dataFileLines[i] componentsSeparatedByCharactersInSet:commaSet];
        NSString *address;
        NSString *latitudeMaker;
        NSString *longitudeMaker;
        
        NSNumber *latitude;
        NSNumber *longitude;
        
        if (fields.count == 4) {
            address = [NSString stringWithFormat:@"%@, %@", fields[0], fields[1]];
            latitudeMaker = [NSString stringWithFormat:@"%@", fields[2]];
            longitudeMaker = [NSString stringWithFormat:@"%@",fields[3]];
            
            latitude = [NSNumber numberWithDouble:[latitudeMaker doubleValue]];
            longitude = [NSNumber numberWithDouble:[longitudeMaker doubleValue]];
        } else {
            address = [NSString stringWithFormat:@"%@", fields[0]];
            latitudeMaker = [NSString stringWithFormat:@"%@", fields[1]];
            longitudeMaker = [NSString stringWithFormat:@"%@",fields[2]];
            
            latitude = [NSNumber numberWithDouble:[latitudeMaker doubleValue]];
            longitude = [NSNumber numberWithDouble:[longitudeMaker doubleValue]];
        }
        
        dump.address = address;
        dump.latitude = latitude;
        dump.longitude = longitude;
        
        [self.context save:&error];
    }
}


@end
