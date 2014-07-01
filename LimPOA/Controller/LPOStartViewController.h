//
//  LPOStartViewController.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/14/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPOAppDelegate.h"
#import "Dump.h"
#import "Container.h"
#import "CookingOil.h"
#import "EcoPoint.h"

@interface LPOStartViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *titleLabel;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
