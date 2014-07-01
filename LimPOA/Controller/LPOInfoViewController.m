//
//  LPOInfoViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 7/1/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOInfoViewController.h"

@interface LPOInfoViewController ()

- (IBAction)confirmButtonTapped:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation LPOInfoViewController

- (void)viewDidLoad
{
    [self getStrings];
    self.confirmButton.layer.cornerRadius = 2;
}

- (IBAction)confirmButtonTapped:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)getStrings
{
    if ([self.type isEqualToString:@"CookingOil"]) {
        self.titleLabel.text = NSLocalizedString(@"cooking_oil_list_title", nil);
        self.infoTextField.text = NSLocalizedString(@"cooking_oil_list_info", nil);
        self.confirmButton.titleLabel.text = NSLocalizedString(@"cooking_oil_list_info_confirm", nil);
    } else if ([self.type isEqualToString:@"EcoPoint"]) {
        self.titleLabel.text = NSLocalizedString(@"ecopoint_list_title", nil);
        self.infoTextField.text = NSLocalizedString(@"ecopoint_list_info", nil);
        self.confirmButton.titleLabel.text = NSLocalizedString(@"ecopoint_list_info_confirm", nil);
    } else if ([self.type isEqualToString:@"Dump"]) {
        self.titleLabel.text = NSLocalizedString(@"dump_list_title", nil);
        self.infoTextField.text = NSLocalizedString(@"dump_list_info", nil);
        self.confirmButton.titleLabel.text = NSLocalizedString(@"dump_list_info_confirm", nil);
    } else if ([self.type isEqualToString:@"Container"]) {
        self.titleLabel.text = NSLocalizedString(@"container_list_title", nil);
        self.infoTextField.text = NSLocalizedString(@"container_list_info", nil);
        self.confirmButton.titleLabel.text = NSLocalizedString(@"container_list_info_confirm", nil);
    }
}
@end
