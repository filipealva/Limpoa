//
//  LPOStartViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/14/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOStartViewController.h"

@interface LPOStartViewController ()
- (IBAction)startButtonWasPressed:(UIButton *)sender;

@end

@implementation LPOStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImage.image = [UIImage imageNamed:self.imageFile];
}

- (IBAction)startButtonWasPressed:(UIButton *)sender
{
    if (self.start) self.start();
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
