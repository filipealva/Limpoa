//
//  LPOCookingOilsTableViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 15/05/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOCookingOilsTableViewController.h"

@interface LPOCookingOilsTableViewController ()

@property (nonatomic, strong) NSMutableArray *cookingOilPoints;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation LPOCookingOilsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Lazy Instantiation

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(LPOAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return _context;
}

- (NSMutableArray *)cookingOilPoints
{
    if (!_cookingOilPoints) {
        _cookingOilPoints = [[NSMutableArray alloc] initWithArray:[self selectAllCookingOilPoints]];
    }
    
    return _cookingOilPoints;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cookingOilPoints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CookingOilCell" forIndexPath:indexPath];
    
    CookingOil *cookingOil = (CookingOil *)[self.cookingOilPoints objectAtIndex:indexPath.row];
    
    NSLog(@"%@", cookingOil);
    
    UILabel *cookingOilName = (UILabel *)[cell viewWithTag:100];
    UILabel *cookingOilAddress = (UILabel *)[cell viewWithTag:200];
    UILabel *distanceToCoookingOilPoint = (UILabel *)[cell viewWithTag:300];
    
    cookingOilName.text = cookingOil.name;
    cookingOilAddress.text = cookingOil.address;
    distanceToCoookingOilPoint.text = @"0.2km";
    
    return cell;
}

#pragma mark - CoreData

- (NSMutableArray *)selectAllCookingOilPoints
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"CookingOil" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    NSMutableArray *cookingOilPointsArray = [[NSMutableArray alloc] init];
    
	NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (CookingOil *cookingOil in fetchedObjects) {
        [cookingOilPointsArray addObject:cookingOil];
    }
    
    if (!error) {
        NSLog(@"OK!");
    } else {
        NSLog(@"ERRO!");
    }
    
    return cookingOilPointsArray;
}


@end
