//
//  LPOInfoViewController.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 7/1/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPOInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextField;

@property (nonatomic, strong) NSString *type;

@end
