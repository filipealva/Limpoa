//
//  LPOPageContentViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 14/05/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOPageContentViewController.h"

@interface LPOPageContentViewController ()

@end

@implementation LPOPageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImage.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
}

@end
