//
//  LPODumpsTableViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/13/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPODumpsTableViewController.h"

@interface LPODumpsTableViewController ()

@property (nonatomic, strong) NSMutableArray *dumps;

@end

@implementation LPODumpsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dumps = [[NSMutableArray alloc] initWithObjects:@"Av. Alberto Bins, 1000", @"R. São Matheus, 1100", nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dumps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DumpCell" forIndexPath:indexPath];
    
    UILabel *dumpAddress = (UILabel *)[cell viewWithTag:100];
    UILabel *distanceToDump = (UILabel *)[cell viewWithTag:200];
    
    dumpAddress.text = self.dumps[indexPath.row];
    distanceToDump.text = @"0.2km";
    
    return cell;
}

@end
