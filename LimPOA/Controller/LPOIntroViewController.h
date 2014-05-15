//
//  LPOIntroViewController.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 14/05/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPOPageContentViewController.h"
#import "LPOStartViewController.h"
#import "Dump.h"
#import "LPOAppDelegate.h"

@interface LPOIntroViewController : UIViewController

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
