//
//  LPOStartViewController.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/14/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPOStartViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *titleLabel;

@property (strong) dispatch_block_t start;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
