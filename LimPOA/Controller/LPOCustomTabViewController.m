//
//  LPOCustomTabViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/13/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOCustomTabViewController.h"

@interface LPOCustomTabViewController ()

@end

@implementation LPOCustomTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Adjust image position to no-title item position.
    for (UITabBarItem *item in self.tabBar.items){
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
}

@end
